module CPU (
    input wire clk
);
    // Declare the signals
    wire [31:0] inst;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire jump;
    wire immediate;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [11:0] immediateValue_12;
    wire [19:0] immediateValue_20;
    wire load;
    wire store;
    wire [2:0] alusel;
    wire [31:0] result;
    wire [31:0] pc;
    wire [31:0] readData1;
    wire [31:0] readData2;
    wire [31:0] memreadData;
    reg branch;
    reg [31:0] operand1;
    reg [31:0] operand2;
    reg [4:0] readReg1;
    reg [4:0] readReg2;
    reg [31:0] writeData;
    reg [31:0] memaddress;
    reg [31:0] memwriteData;

    // Add other signals as needed


    // Instruction Memory
    InstructionMemory instMem (
        .address(pc),
        .instruction(inst)
        // Add other connections as needed
    );

    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(inst),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
        // Add other connections as needed
    );

    // Control Unit
    ControlUnit ctrlUnit (
        .instruction(inst),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs2(rs2),
        .rs1(rs1),
        .rd(rd),
        .load(load),
        .store(store),
        .jump(jump),
        .alusel(alusel),
        .immediate(immediate),
        .immediateValue_12(immediateValue_12),
        .immediateValue_20(immediateValue_20)
        // Add other connections as needed
    );

    // ALU
    ALU alu (
        .operand1(operand1),
        .operand2(operand2),
        .alusel(alusel),
        .result(result)
        // Add other connections as needed
    );

    // Program Counter (PC)
    PC pcUnit (
        .clk(clk),
        .branchAddress(immediateValue_12),
        .jumpAddress(immediateValue_20),
        .branch(branch),
        .jump(jump),
        .pc(pc)
        // Add other connections as needed
    );

    // Register File
    RegisterFile regFile (
        .clk(clk),
        .writeReg(rd),
        .writeEnable(load),
        .readReg1(rs1),
        .readReg2(rs2),
        .writeData(writeData),
        .readData1(readData1),
        .readData2(readData2)
        // Add other connections as needed
    );

    MemoryUnit memunit(
        .clk(clk),
        .address(memaddress),
        .writeData(store),
        .memWrite(memWrite),
        .readData(memreadData)
    );

    always @* begin
        if(opcode==7'b0110011) begin // R-type instructions
            operand1<=readData1;
            operand2<=readData2;
            writeData=result;
        end
        if(opcode==7'b0010011) begin // I-type instructions
            operand1<=readData1;
            operand2<=$signed({{20{immediateValue_12[11]}}, immediateValue_12});
            writeData=result;
        end
        if(opcode==7'b0000011) begin // Load instructions
            memaddress=readData1+$signed({{20{immediateValue_12[11]}}, immediateValue_12});
            writeData=memreadData;
        end
        if(opcode==7'b0100011) begin // Store instructions
            memaddress=readData1+$signed({{20{immediateValue_12[11]}}, immediateValue_12});
            memwriteData=readData2;
        end
        if(opcode==7'b1100011) begin // B-type instructions (Branch)
            branch<=0;
            if(readData1==readData2)begin
                branch=1;
            end
        end
        if(opcode==7'b1101111) begin // J-type instructions (Jump)
            writeData<=pc+4;
        end
    end
endmodule