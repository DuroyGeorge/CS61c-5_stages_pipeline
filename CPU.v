module CPU (
    input wire clk
);
    // Pipeline wires
    wire [31:0] pc;
    wire [31:0] _ID_inst;
    wire [31:0] _ID_funct7;
    wire [31:0] _ID_funct3;
    wire [31:0] _ID_opcode;

    wire [31:0] _EX_inst;
    wire [31:0] _EX_pc;
    wire [6:0] _EX_opcode;
    wire [6:0] _EX_funct3;
    wire [6:0] _EX_funct7;
    wire [4:0] _EX_rs1;
    wire [4:0] _EX_rs2;
    wire [4:0] _EX_rd;
    wire [11:0] _EX_immediateValue_12;
    wire [19:0] _EX_immediateValue_20;   
    wire [4:0] _EX_operand1;
    wire [4:0] _EX_operand2;
    wire [2:0] _EX_alusel;
    wire [31:0] _EX_readData1;
    wire [31:0] _EX_readData2;
    wire _EX_jump;
    wire _EX_load;
    wire _EX_store;

    wire [31:0] _MEM_inst;
    wire [31:0] _MEM_pc;
    wire [6:0] _MEM_opcode;
    wire [4:0] _MEM_rd;
    wire _MEM_load;
    wire _MEM_store;
    wire _MEM_branch;
    wire _MEM_jump;
    wire [31:0] _MEM_memaddress;
    wire [31:0] _MEM_readData1;
    wire [31:0] _MEM_readData2;
    wire [31:0] _MEM_result;

    wire [31:0] _WB_inst;
    wire [31:0] _WB_pc;
    wire [6:0] _WB_opcode;
    wire [4:0] _WB_rd;
    wire _WB_load;
    wire _WB_jump;
    wire _WB_branch;
    wire [31:0] _WB_memreadData;
    wire [31:0] _WB_result;

    wire [31:0] inst_IF;
    wire [31:0] pc_IF;
    wire [31:0] funct7_IF;
    wire [31:0] funct3_IF;
    wire [31:0] opcode_IF;

    wire [31:0] inst_ID;
    wire [31:0] pc_ID;
    wire [6:0] opcode_ID;
    wire [6:0] funct3_ID;
    wire [6:0] funct7_ID;
    wire [4:0] rs1_ID;
    wire [4:0] rs2_ID;
    wire [4:0] rd_ID;
    wire [11:0] immediateValue_12_ID;
    wire [19:0] immediateValue_20_ID;   
    wire [4:0] operand1_ID;
    wire [4:0] operand2_ID;
    wire [2:0] alusel_ID;
    wire [31:0] readData1_ID;
    wire [31:0] readData2_ID;
    wire jump_ID;
    wire load_ID;
    wire store_ID;

    wire [31:0] inst_EX;
    wire [31:0] pc_EX;
    wire [6:0] opcode_EX;
    wire [4:0] rd_EX;
    wire load_EX;
    wire store_EX;
    wire branch_EX;
    wire jump_EX;
    wire [31:0] memaddress_EX;
    wire [31:0] readData1_EX;
    wire [31:0] readData2_EX;
    wire [31:0] result_EX;

    wire [31:0] inst_MEM;
    wire [31:0] pc_MEM;
    wire [6:0] opcode_MEM;
    wire [4:0] rd_MEM;
    wire load_MEM;
    wire jump_MEM;
    wire branch_MEM;
    wire [31:0] memreadData_MEM;
    wire [31:0] result_MEM;

    //Pipeline Registers
    reg [31:0] ID_inst;
    reg [31:0] ID_pc;
    reg [31:0] ID_funct7;
    reg [31:0] ID_funct3;
    reg [31:0] ID_opcode;

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

    assign _ID_inst=ID_inst;
    assign _ID_funct3=ID_funct3;
    assign _ID_funct7=ID_funct7;
    assign _ID_opcode=ID_opcode;

    assign _EX_inst=EX_inst;
    assign _EX_pc=EX_pc;
    assign _EX_opcode=EX_opcode;
    assign _EX_funct3=EX_funct3;
    assign _EX_funct7=EX_funct7;
    assign _EX_rs1=EX_rs1;
    assign _EX_rs2=EX_rs2;
    assign _EX_rd=EX_rd;
    assign _EX_immediateValue_12=EX_immediateValue_12;
    assign _EX_immediateValue_20=EX_immediateValue_20;
    assign _EX_alusel = EX_alusel;
    assign _EX_readData1 = EX_readData1;
    assign _EX_readData2 = EX_readData2;
    assign _EX_jump = EX_jump;
    assign _EX_immediate = EX_immediate;
    assign _EX_load = EX_load;
    assign _EX_store = EX_store;

    assign _MEM_inst = MEM_inst;
    assign _MEM_pc = MEM_pc;
    assign _MEM_opcode = MEM_opcode;
    assign _MEM_rd = MEM_rd;
    assign _MEM_load = MEM_load;
    assign _MEM_store = MEM_store;
    assign _MEM_branch = MEM_branch;
    assign _MEM_jump = MEM_jump;
    assign _MEM_memaddress = MEM_result;
    assign _MEM_readData1 = MEM_readData1;
    assign _MEM_readData2 = MEM_readData2;
    assign _MEM_result = MEM_result;

    assign _WB_inst = WB_inst;
    assign _WB_pc = WB_pc;
    assign _WB_opcode = WB_opcode;
    assign _WB_rd = WB_rd;
    assign _WB_load = WB_load;
    assign _WB_jump = WB_jump;
    assign _WB_memreadData = WB_memreadData;
    assign _WB_result = WB_result;
    assign _WB_branch = WB_branch;

    // Instruction Memory
    InstructionMemory instMem (
        .address(pc),
        .instruction(inst_ID)
        // Add other connections as needed
    );

    // Program Counter (PC)
    PC pcUnit (
        .clk(clk),
        .newpc(_WB_pc),
        .branch(_WB_branch),
        .jump(_WB_jump),
        .pc(pc)
        // Add other connections as needed
    );
    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(inst_ID),
        .funct7(funct7_ID),
        .funct3(funct3_ID),
        .opcode(opcode_ID),
        .rs1(rs1_ID),
        .rs2(rs2_ID),
        .rd(rd_ID)
        // Add other connections as needed
    );
    // Control Unit
    ControlUnit ctrlUnit (
        .instruction(IF_ID_inst),
        .opcode(IF_ID_opcode),
        .funct3(IF_ID_funct3),
        .funct7(IF_ID_funct7),
        .rs1(_ID_rs1),
        .rs2(_ID_rs2),
        .rd(_ID_rd),
        .jump(jump_EX),
        .alusel(alusel_EX),
        .immediate(immediate_EX),
        .load(load_EX),
        .store(store_EX),
        .immediateValue_12(immediateValue_12_EX),
        .immediateValue_20(immediateValue_20_EX)
        // Add other connections as needed
    );
    // ALU
    ALU alu (
        .operand1(_EX_operand1),
        .operand2(_EX_operand2),
        .alusel(_EX_alusel),
        .result(result_MEM)
        // Add other connections as needed
    );
    // Register File
    RegisterFile regFile (
        .clk(clk),
        .writeReg(_WB_rd),
        .writeData(_WB_writedata),
        .writeEnable(_WB_load),
        .readReg1(ID_EX_rs1),
        .readReg2(ID_EX_rs2),
        .readData1(readData1_ID),
        .readData2(readData2_ID)
        // Add other connections as needed
    );
    MemoryUnit memunit(
        .clk(clk),
        .address(_MEM_memaddress),
        .writeData(_MEM_readData2),
        .memWrite(_MEM_store),
        .readData(WB_memreadData_MEM)
    );


    initial begin
        // Initialize ID stage registers
        ID_inst = 32'b0;
        ID_pc = 32'b0;
        ID_funct7 = 32'b0;
        ID_funct3 = 32'b0;
        ID_opcode = 32'b0;

        // Initialize EX stage registers
        EX_inst = 32'b0;
        EX_pc = 32'b0;
        EX_funct3 = 7'b0;
        EX_funct7 = 7'b0;
        EX_opcode = 7'b0;
        EX_rs1 = 5'b0;
        EX_rs2 = 5'b0;
        EX_rd = 5'b0;
        EX_immediateValue_12 = 12'b0;
        EX_immediateValue_20 = 20'b0;
        EX_alusel = 3'b0;
        EX_readData1 = 32'b0;
        EX_readData2 = 32'b0;
        EX_jump = 1'b0;
        EX_immediate = 1'b0;
        EX_load = 1'b0;
        EX_store = 1'b0;

        // Initialize MEM stage registers
        MEM_inst = 32'b0;
        MEM_pc = 32'b0;
        MEM_opcode = 7'b0;
        MEM_rd = 5'b0;
        MEM_load = 1'b0;
        MEM_store = 1'b0;
        MEM_jump = 1'b0;
        MEM_branch = 1'b0;
        MEM_readData1 = 32'b0;
        MEM_readData2 = 32'b0;
        MEM_result = 32'b0;
        MEM_writedata = 32'b0;

        // Initialize WB stage registers
        WB_inst = 32'b0;
        WB_pc = 32'b0;
        WB_opcode = 7'b0;
        WB_rd = 5'b0;
        WB_load = 1'b0;
        WB_jump = 1'b0;
        WB_branch = 1'b0;
        WB_result = 32'b0;
        WB_memreadData = 32'b0;
        WB_writedata = 32'b0;
    end

    assign _EX_operand1=(EX_opcode==7'b0110011||EX_opcode==7'b0010011||EX_opcode==7'b0000011||EX_opcode==7'b0100011)?EX_readData1:((EX_opcode==7'b1101111||EX_opcode==7'b1100011)?EX_pc:32'b0);
    assign _EX_operand2=(EX_opcode==7'b0110011)?EX_readData2:((EX_opcode==7'b0000011||EX_opcode==7'b0100011||EX_opcode==7'b0010011||EX_opcode==7'b1100011)?$signed({{20{EX_immediateValue_12[11]}},EX_immediateValue_12}):((EX_opcode==7'b1101111)?$signed({{12{EX_immediateValue_20[19]}},EX_immediateValue_20}):32'b0));
    assign _WB_writedata=(WB_opcode==7'b0110011||WB_opcode==7'b0010011)?WB_result:((WB_opcode==7'b0000011)?WB_memreadData:((WB_opcode==7'b1101111)?WB_pc:32'b0));

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
        ID_pc<=pc;
        ID_inst<=inst_IF;
        ID_funct7<=ID_funct7_IF;
        ID_funct3<=ID_funct3_IF;
        ID_opcode<=ID_opcode_IF;

        //ID

        EX_inst<=ID_inst;
        EX_pc<=ID_pc;
        EX_funct3<=ID_funct3;
        EX_funct7<=ID_funct7;

        EX_opcode<=opcode_ID;
        EX_rs1<=rs1_ID;
        EX_rs2<=rs2_ID;
        EX_rd<=rd_ID;
        EX_immediateValue_12<=immediateValue_12_ID;
        EX_immediateValue_20<=immediateValue_20_ID;
        EX_alusel<=alusel_ID;
        EX_readData1<=regFile.readData1;
        EX_readData2<=regFile.readData2;
        EX_jump<=jump_ID;
        EX_load<=load_ID;
        EX_store<=store_ID;

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