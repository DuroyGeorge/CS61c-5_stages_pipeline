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

    // Pipeline Registers
    reg [31:0] IF_ID_inst;
    reg [31:0] IF_ID_pc;
    reg [6:0] IF_ID_opcode;
    reg [2:0] IF_ID_funct3;
    reg [6:0] IF_ID_funct7;
    reg [4:0] IF_ID_rs1;
    reg [4:0] IF_ID_rs2;
    reg [4:0] IF_ID_rd;
    reg [11:0] IF_ID_immediateValue_12;
    reg [19:0] IF_ID_immediateValue_20;

    reg [31:0] ID_EX_inst;
    reg [31:0] ID_EX_pc ;
    reg [6:0] ID_EX_opcode;
    reg [4:0] ID_EX_rd;
    reg [11:0] ID_EX_immediateValue_12;
    reg [19:0] ID_EX_immediateValue_20;   
    reg [4:0] ID_EX_operand1;
    reg [4:0] ID_EX_operand2;
    reg [2:0] ID_EX_alusel;
    reg [31:0] ID_EX_readData1;
    reg [31:0] ID_EX_readData2;
    reg ID_EX_jump;
    reg ID_EX_branch;
    reg ID_EX_immediate;
    reg ID_EX_load;
    reg ID_EX_store;

    reg [31:0] EX_MEM_inst;
    reg [31:0] EX_MEM_pc;
    reg [6:0] EX_MEM_opcode;
    reg [4:0] EX_MEM_rd;
    reg EX_MEM_load;
    reg EX_MEM_store;
    reg [31:0] EX_MEM_readData1;
    reg [31:0] EX_MEM_readData2;
    reg [31:0] EX_MEM_result;

    reg [31:0] MEM_WB_inst;
    reg [31:0] MEM_WB_pc;
    reg [6:0] MEM_WB_opcode;
    reg [4:0] MEM_WB_rd;
    reg MEM_WB_load;
    reg [31:0] MEM_WB_memreadData;
    reg [31:0] MEM_WB_result;

    // Instruction Memory
    InstructionMemory instMem (
        .address(pc),
        .instruction(IF_ID_inst)
        // Add other connections as needed
    );

    // Program Counter (PC)
    PC pcUnit (
        .clk(clk),
        .branchAddress(ID_EX_immediateValue_12),
        .jumpAddress(ID_EX_immediateValue_20),
        .branch(ID_EX_branch),
        .jump(ID_EX_jump),
        .pc(pc)
        // Add other connections as needed
    );
    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(IF_ID_inst),
        .opcode(IF_ID_opcode),
        .funct3(IF_ID_funct3),
        .funct7(IF_ID_funct7),
        .rs1(IF_ID_rs1),
        .rs2(IF_ID_rs2),
        .rd(IF_IF_rd)
        // Add other connections as needed
    );
    // ALU
    ALU alu (
        .operand1(ID_EX_operand1),
        .operand2(ID_EX_operand2),
        .alusel(ID_EX_alusel),
        .result(EX_MEM_result)
        // Add other connections as needed
    );
    // Register File
    RegisterFile regFile (
        .clk(clk),
        .writeReg(MEM_WB_rd),
        .writeEnable(MEM_WB_load),
        .readReg1(IF_ID_rs1),
        .readReg2(IF_ID_rs2),
        .writeData(MEM_WB_load_writeData),
        .readData1(ID_EX_readData1),
        .readData2(ID_EX_readData2)
        // Add other connections as needed
    );
    MemoryUnit memunit(
        .clk(clk),
        .address(EX_MEM_memaddress),
        .writeData(EX_MEM_store),
        .memWrite(EX_MEM_memWrite),
        .readData(EX_MEM_memreadData)
    );
    // Control Unit
    ControlUnit ctrlUnit (
        .instruction(inst),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs2(rs2),
        .jump(jump),
        .alusel(alusel),
        .immediate(immedia
        .rs1(rs1),
        .rd(rd),
        .load(load),
        .store(store),te),
        .immediateValue_12(immediateValue_12),
        .immediateValue_20(immediateValue_20)
        // Add other connections as needed
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