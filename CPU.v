module CPU (
    input wire clk
);
    // Pipeline wires
    wire [31:0] IF_ID_inst;
    wire [31:0] IF_ID_pc;
    wire [31:0] IF_ID_funct3;
    wire [31:0] IF_ID_funct7;

    wire [31:0] ID_EX_inst;
    wire [31:0] ID_EX_pc ;
    wire [6:0] ID_EX_opcode;
    wire [6:0] ID_EX_funct3;
    wire [6:0] ID_EX_funct7;
    wire [4:0] ID_EX_rs1;
    wire [4:0] ID_EX_rs2;
    wire [4:0] ID_EX_rd;
    wire [11:0] ID_EX_immediateValue_12;
    wire [19:0] ID_EX_immediateValue_20;   
    wire [4:0] ID_EX_operand1;
    wire [4:0] ID_EX_operand2;
    wire [2:0] ID_EX_alusel;
    wire [31:0] ID_EX_readData1;
    wire [31:0] ID_EX_readData2;
    wire ID_EX_jump;
    wire ID_EX_immediate;
    wire ID_EX_load;
    wire ID_EX_store;

    wire [31:0] EX_MEM_inst;
    wire [31:0] EX_MEM_pc;
    wire [6:0] EX_MEM_opcode;
    wire [4:0] EX_MEM_rd;
    wire EX_MEM_load;
    wire EX_MEM_store;
    wire EX_MEM_branch;
    wire EX_MEM_jump;
    wire [31:0] EX_MEM_memaddress;
    wire [31:0] EX_MEM_readData1;
    wire [31:0] EX_MEM_readData2;
    wire [31:0] EX_MEM_result;

    wire [31:0] MEM_WB_inst;
    wire [31:0] MEM_WB_pc;
    wire [6:0] MEM_WB_opcode;
    wire [4:0] MEM_WB_rd;
    wire MEM_WB_load;
    wire MEM_WB_jump;
    wire MEM_WB_branch;
    wire [31:0] MEM_WB_memreadData;
    wire [31:0] MEM_WB_result;
    wire [31:0] MEM_WB_writedata;

    //Pipeline Registers
    reg [31:0] ID_inst;
    reg [31:0] ID_pc;
    reg [31:0] ID_funct3;
    reg [31:0] ID_funct7;

    reg [31:0] EX_inst;
    reg [31:0] EX_pc ;
    reg [6:0] EX_funct3;
    reg [6:0] EX_funct7;
    reg [6:0] EX_opcode;
    reg [4:0] EX_rs1;
    reg [4:0] EX_rs2;
    reg [4:0] EX_rd;
    reg [11:0] EX_immediateValue_12;
    reg [19:0] EX_immediateValue_20;   
    reg [2:0] EX_alusel;
    reg [31:0] EX_readData1;
    reg [31:0] EX_readData2;
    reg EX_jump;
    reg EX_immediate;
    reg EX_load;
    reg EX_store;

    reg [31:0] MEM_inst;
    reg [31:0] MEM_pc;
    reg [6:0] MEM_opcode;
    reg [4:0] MEM_rd;
    reg MEM_load;
    reg MEM_store;
    reg MEM_jump;
    reg MEM_branch;
    reg [31:0] MEM_readData1;
    reg [31:0] MEM_readData2;
    reg [31:0] MEM_result;
    reg [31:0] MEM_writedata;

    reg [31:0] WB_inst;
    reg [31:0] WB_pc;
    reg [6:0] WB_opcode;
    reg [4:0] WB_rd;
    reg WB_load;
    reg WB_jump;
    reg WB_branch;
    reg [31:0] WB_result;
    reg [31:0] WB_memreadData;
    reg [31:0] WB_writedata;

    assign IF_ID_inst=ID_inst;
    assign IF_ID_pc=ID_pc;
    assign IF_ID_funct3=ID_funct3;
    assign IF_ID_funct7=ID_funct7;

    assign ID_EX_inst=EX_inst;
    assign ID_EX_pc=EX_pc;
    assign ID_EX_opcode=EX_opcode;
    assign ID_EX_funct3=EX_funct3;
    assign ID_EX_funct7=EX_funct7;
    assign ID_EX_rs1=EX_rs1;
    assign ID_EX_rs2=EX_rs2;
    assign ID_EX_rd=EX_rd;
    assign ID_EX_immediateValue_12=EX_immediateValue_12;
    assign ID_EX_immediateValue_20=EX_immediateValue_20;
    assign ID_EX_alusel = EX_alusel;
    assign ID_EX_readData1 = EX_readData1;
    assign ID_EX_readData2 = EX_readData2;
    assign ID_EX_jump = EX_jump;
    assign ID_EX_immediate = EX_immediate;
    assign ID_EX_load = EX_load;
    assign ID_EX_store = EX_store;

    assign EX_MEM_inst = MEM_inst;
    assign EX_MEM_pc = MEM_pc;
    assign EX_MEM_opcode = MEM_opcode;
    assign EX_MEM_rd = MEM_rd;
    assign EX_MEM_load = MEM_load;
    assign EX_MEM_store = MEM_store;
    assign EX_MEM_branch = MEM_branch;
    assign EX_MEM_jump = MEM_jump;
    assign EX_MEM_memaddress = MEM_result;
    assign EX_MEM_readData1 = MEM_readData1;
    assign EX_MEM_readData2 = MEM_readData2;

    assign MEM_WB_inst = WB_inst;
    assign MEM_WB_pc = WB_pc;
    assign MEM_WB_opcode = WB_opcode;
    assign MEM_WB_rd = WB_rd;
    assign MEM_WB_load = WB_load;
    assign MEM_WB_jump = WB_jump;
    assign MEM_WB_memreadData = WB_memreadData;
    assign MEM_WB_result = WB_result;

    // Instruction Memory
    InstructionMemory instMem (
        .address(IF_ID_pc),
        .instruction(IF_ID_inst)
        // Add other connections as needed
    );

    // Program Counter (PC)
    PC pcUnit (
        .clk(clk),
        .newpc(MEM_WB_pc),
        .branch(MEM_WB_branch),
        .jump(MEM_WB_jump),
        .pc(IF_ID_pc)
        // Add other connections as needed
    );
    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(IF_ID_inst),
        .opcode(IF_ID_opcode),
        .funct3(IF_ID_funct3),
        .funct7(IF_ID_funct7),
        .rs1(ID_EX_rs1),
        .rs2(ID_EX_rs2),
        .rd(ID_EX_rd)
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
        .writeData(MEM_WB_writedata),
        .writeEnable(MEM_WB_load),
        .readReg1(IF_ID_rs1),
        .readReg2(IF_ID_rs2),
        .readData1(ID_EX_readData1),
        .readData2(ID_EX_readData2)
        // Add other connections as needed
    );
    MemoryUnit memunit(
        .clk(clk),
        .address(EX_MEM_memaddress),
        .writeData(EX_MEM_readData2),
        .memWrite(EX_MEM_store),
        .readData(MEM_WB_memreadData)
    );
    // Control Unit
    ControlUnit ctrlUnit (
        .instruction(IF_ID_inst),
        .opcode(IF_ID_opcode),
        .funct3(IF_ID_funct3),
        .funct7(IF_ID_funct7),
        .rs1(ID_EX_rs1),
        .rs2(ID_EX_rs2),
        .rd(ID_EX_rd),
        .jump(ID_EX_jump),
        .alusel(ID_EX_alusel),
        .immediate(ID_EX_immediate),
        .load(ID_EX_load),
        .store(ID_EX_store),
        .immediateValue_12(ID_EX_immediateValue_12),
        .immediateValue_20(ID_EX_immediateValue_20)
        // Add other connections as needed
    );

    assign ID_EX_operand1=(EX_opcode==7'b0110011||EX_opcode==7'b0010011||EX_opcode==7'b0000011||EX_opcode==7'b0100011)?EX_readData1:((EX_opcode==7'b1101111||EX_opcode==7'b1100011)?EX_pc:32'b0);
    assign ID_EX_operand2=(EX_opcode==7'b0110011)?EX_readData2:((EX_opcode==7'b0000011||EX_opcode==7'b0100011||EX_opcode==7'b0010011||EX_opcode==7'b1100011)?$signed({20{EX_immediateValue_12[11]},EX_immediateValue_12}):((EX_opcode==7'b1101111)?$signed({12{EX_immediateValue_20[19]},EX_immediateValue_20}):32'b0));
    assign MEM_WB_writedata=(WB_opcode==7'b0110011||WB_opcode==7'b0010011)?WB_result:((WB_opcode==7'b0000011)?WB_memreadData:((WB_opcode==7'b1101111)?WB_pc:32'b0));

    always @(posedge clk) begin
        // if(opcode==7'b0110011) begin // R-type instructions
        //     operand1<=readData1;
        //     operand2<=readData2;
        //     writeData=result;
        // end
        // if(opcode==7'b0010011) begin // I-type instructions
        //     operand1<=readData1;
        //     operand2<=$signed({{20{immediateValue_12[11]}}, immediateValue_12});
        //     writeData=result;
        // end
        // if(opcode==7'b0000011) begin // Load instructions
        //     memaddress=readData1+$signed({{20{immediateValue_12[11]}}, immediateValue_12});
        //     writeData=memreadData;
        // end
        // if(opcode==7'b0100011) begin // Store instructions
        //     memaddress=readData1+$signed({{20{immediateValue_12[11]}}, immediateValue_12});
        //     memwriteData=readData2;
        // end
        // if(opcode==7'b1100011) begin // B-type instructions (Branch)
        //     branch<=0;
        //     if(readData1==readData2)begin
        //         branch=1;
        //     end
        // end
        // if(opcode==7'b1101111) begin // J-type instructions (Jump)
        //     writeData<=pc+4;
        // end

        //IF
        ID_inst<=IF_ID_inst;
        ID_pc<=IF_ID_pc;
        ID_funct3<=IF_ID_funct3;
        ID_funct7<=IF_ID_funct7;

        //ID

        EX_inst<=ID_inst;
        EX_pc<=ID_pc;
        EX_funct3<=ID_funct3;
        EX_funct7<=ID_funct7;

        EX_opcode<=ID_EX_opcode;
        EX_rs1<=ID_EX_rs1;
        EX_rs2<=ID_EX_rs2;
        EX_rd<=ID_EX_rd;
        EX_immediateValue_12<=ID_EX_immediateValue_12;
        EX_immediateValue_20<=ID_EX_immediateValue_20;
        EX_alusel<=ID_EX_alusel;
        EX_readData1<=ID_EX_readData1;
        EX_readData2<=ID_EX_readData2;
        EX_jump<=ID_EX_jump;
        EX_immediate<=ID_EX_immediate;
        EX_load<=ID_EX_load;
        EX_store<=ID_EX_store;

        //EX
        MEM_pc<=EX_pc;
        MEM_inst<=EX_inst;
        MEM_opcode<=EX_opcode;
        MEM_rd<=EX_rd;
        MEM_load<=EX_load;
        MEM_store<=EX_store;
        MEM_jump<=EX_jump;
        MEM_readData1<=EX_readData1;
        MEM_readData2<=EX_readData2;

        MEM_result<=alu.result;
        MEM_branch<=0;
        MEM_writedata<=EX_pc+4;

        if(EX_opcode==7'b1100011 && EX_readData1==EX_readData2) begin
            MEM_branch<=1;
            MEM_pc<=alu.result;
        end
        if(EX_opcode==7'b1101111)begin
            MEM_jump<=1;
            MEM_pc<=alu.result;
        end
        //MEM

        WB_inst<=MEM_inst;
        WB_pc<=MEM_pc;
        WB_opcode<=MEM_opcode;
        WB_rd<=MEM_rd;
        WB_load<=MEM_load;
        WB_jump<=MEM_jump;
        WB_branch<=MEM_branch;
        WB_result<=MEM_result;
        WB_writedata<=MEM_writedata;

        WB_memreadData<=memunit.readData;

        //WB

    end
endmodule