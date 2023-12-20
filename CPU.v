module CPU (
    input wire clk
);
    // Pipeline wires
    wire [31:0] pc;
    wire [31:0] _ID_inst;
    wire [6:0] _ID_funct7;
    wire [2:0] _ID_funct3;
    wire [7:0] _ID_opcode;
    wire [4:0] _ID_rs1;
    wire [4:0] _ID_rs2;
    wire [4:0] _ID_rd;

    wire [31:0] _EX_operand1;
    wire [31:0] _EX_operand2;
    wire [2:0] _EX_alusel;

    wire _MEM_store;
    wire [31:0] _MEM_readData2;
    wire [31:0] _MEM_result;
    wire _MEM_branch;
    wire _MEM_jump;

    wire [4:0] _WB_rd;
    wire [31:0] _WB_writedata;
    wire _WB_load;
    wire [31:0] _WB_result;

    wire [31:0] inst_IF;
    wire [31:0] pc_IF;
    wire [6:0] funct7_IF;
    wire [2:0] funct3_IF;
    wire [6:0] opcode_IF;
    wire [4:0] rs1_IF;
    wire [4:0] rs2_IF;
    wire [4:0] rd_IF;


    wire [11:0] immediateValue_12_ID;
    wire [19:0] immediateValue_20_ID;   
    wire [2:0] alusel_ID;
    wire [31:0] readData1_ID;
    wire [31:0] readData2_ID;
    wire jump_ID;
    wire load_ID;
    wire store_ID;

    wire [31:0] result_EX;

    wire [31:0] memreadData_MEM;

    wire _nop;

    //Pipeline Registers
    reg [31:0] ID_pc;
    reg [31:0] ID_inst;
    reg [6:0] ID_funct7;
    reg [4:0] ID_rs2; 
    reg [4:0] ID_rs1;
    reg [2:0] ID_funct3;
    reg [4:0] ID_rd;
    reg [6:0] ID_opcode;

    reg [31:0] EX_inst;
    reg [31:0] EX_pc ;
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
    reg [6:0] WB_opcode;
    reg [4:0] WB_rd;
    reg WB_load;
    reg [31:0] WB_result;
    reg [31:0] WB_memreadData;
    reg [31:0] WB_writedata;

    reg nop;
    reg stall;

    assign _ID_inst=ID_inst;
    assign _ID_funct7=ID_funct7;
    assign _ID_rs2=ID_rs2;
    assign _ID_rs1=ID_rs1;
    assign _ID_rd=ID_rd;
    assign _ID_funct3=ID_funct3;
    assign _ID_opcode=ID_opcode;

    assign _EX_alusel = EX_alusel;

    assign _MEM_store = MEM_store;
    assign _MEM_readData2 = MEM_readData2;
    assign _MEM_result = MEM_result;
    assign _MEM_branch=MEM_branch;
    assign _MEM_jump=MEM_jump;

    assign _WB_rd = WB_rd;
    assign _WB_load = WB_load;
    assign _WB_result = WB_result;

    assign _nop=nop;


    // Instruction Memory
    InstructionMemory instMem (
        .address(pc),
        .instruction(inst_IF)
        // Add other connections as needed
    );

    // Program Counter (PC)
    PC pcUnit (
        .clk(clk),
        .newpc(_MEM_result),
        .branch(_MEM_branch),
        .jump(_MEM_jump),
        .pc(pc),
        .nop(_nop)
        // Add other connections as needed
    );
    // Instruction Decoder
    InstructionDecoder instDecoder (
        .instruction(inst_IF),
        .funct7(funct7_IF),
        .rs2(rs2_IF),
        .rs1(rs1_IF),
        .funct3(funct3_IF),
        .rd(rd_IF),
        .opcode(opcode_IF)
        // Add other connections as needed
    );
    // Control Unit
    ControlUnit ctrlUnit (
        .instruction(_ID_inst),
        .funct7(_ID_funct7),
        .rs2(_ID_rs2),
        .rs1(_ID_rs1),
        .funct3(_ID_funct3),
        .rd(_ID_rd),
        .opcode(_ID_opcode),
        .jump(jump_ID),
        .alusel(alusel_ID),
        .load(load_ID),
        .store(store_ID),
        .immediateValue_12(immediateValue_12_ID),
        .immediateValue_20(immediateValue_20_ID)
        // Add other connections as needed
    );
    // ALU
    ALU alu (
        .operand1(_EX_operand1),
        .operand2(_EX_operand2),
        .alusel(_EX_alusel),
        .result(result_EX)
        // Add other connections as needed
    );
    // Register File
    RegisterFile regFile (
        .clk(clk),
        .writeReg(_WB_rd),
        .writeData(_WB_writedata),
        .writeEnable(_WB_load),
        .readReg2(_ID_rs2),
        .readReg1(_ID_rs1),
        .readData2(readData2_ID),
        .readData1(readData1_ID)
        // Add other connections as needed
    );
    MemoryUnit memunit(
        .clk(clk),
        .address(_MEM_result),
        .writeData(_MEM_readData2),
        .memWrite(_MEM_store),
        .readData(memreadData_MEM)
    );


    initial begin
        // Initialize ID stage registers
        ID_inst = 32'b0;
        ID_pc = 32'b0;
        ID_funct7 = 32'b0;
        ID_rs2 = 5'b0;
        ID_rs1 = 5'b0;
        ID_funct3 = 32'b0;
        ID_rd = 5'b0;
        ID_opcode = 32'b0;

        // Initialize EX stage registers
        EX_inst = 32'b0;
        EX_pc = 32'b0;
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
        WB_opcode = 7'b0;
        WB_rd = 5'b0;
        WB_load = 1'b0;
        WB_result = 32'b0;
        WB_memreadData = 32'b0;
        WB_writedata = 32'b0;

        nop=1'b0;
        stall=1'b0;

    end

    assign _EX_operand1=(EX_opcode==7'b0110011||EX_opcode==7'b0010011||EX_opcode==7'b0000011||EX_opcode==7'b0100011)?EX_readData1:((EX_opcode==7'b1101111||EX_opcode==7'b1100011)?EX_pc:32'b0);
    assign _EX_operand2=(EX_opcode==7'b0110011)?EX_readData2:((EX_opcode==7'b0000011||EX_opcode==7'b0100011||EX_opcode==7'b0010011||EX_opcode==7'b1100011)?$signed({{20{EX_immediateValue_12[11]}},EX_immediateValue_12}):((EX_opcode==7'b1101111)?$signed({{12{EX_immediateValue_20[19]}},EX_immediateValue_20}):32'b0));
    assign _WB_writedata=(WB_opcode==7'b0110011||WB_opcode==7'b0010011)?WB_result:((WB_opcode==7'b0000011)?WB_memreadData:((WB_opcode==7'b1101111)?WB_writedata:32'b0));

    always @(posedge clk) begin
        if(nop)begin
            nop<=0;
        end

        //register access
        WB_load=MEM_load;
        //forwarding
        if(ID_opcode==7'b0110011||ID_opcode==7'b1100011) begin//R B
            if(EX_rd==ID_rs1)begin
                EX_readData1=alu.result;
            end
            if(EX_rd==ID_rs2)begin
                EX_readData2=alu.result;
            end
            if(MEM_opcode==7'b0000011&&MEM_rd==ID_rs1)begin
                EX_readData1=memunit.readData;
            end
            if(MEM_opcode==7'b0000011&&MEM_rd==ID_rs2)begin
                EX_readData2=memunit.readData;
            end
            if(EX_opcode==7'b0000011&&(EX_rd==ID_rs1||EX_rd==ID_rs2))begin
                EX_pc<=0;
                EX_inst<=0;
                EX_rs2<=0;
                EX_rs1<=0;
                EX_opcode<=0;
                EX_rd<=0;
                EX_immediateValue_12<=0;
                EX_immediateValue_20<=0;
                EX_alusel<=0;
                EX_jump<=0;
                EX_load<=0;
                EX_store<=0;
                nop<=1;
                stall=1;
            end
            EX_readData1=regFile.readData1;
            EX_readData2=regFile.readData2;
        end
        else if(ID_opcode==7'b0010011)begin//I
            if(EX_rd==ID_rs1)begin
                EX_readData1=alu.result;
            end
            if(MEM_opcode==7'b0000011&&MEM_rd==ID_rs1)begin
                EX_readData1=memunit.readData;
            end
            if(EX_opcode==7'b0000011&&EX_rd==EX_rs1)begin
                EX_pc<=0;
                EX_inst<=0;
                EX_rs2<=0;
                EX_rs1<=0;
                EX_opcode<=0;
                EX_rd<=0;
                EX_immediateValue_12<=0;
                EX_immediateValue_20<=0;
                EX_alusel<=0;
                EX_jump<=0;
                EX_load<=0;
                EX_store<=0;
                nop<=1;
                stall=1;
            end
            EX_readData1=regFile.readData1;
            EX_readData2=regFile.readData2;
        end
        else begin
            EX_readData1=regFile.readData1;
            EX_readData2=regFile.readData2;
        end

        //IF
        if(stall)begin
            stall=0;
        end
        else begin
            ID_pc<=pc;
            ID_inst<=inst_IF;
            ID_funct7<=funct7_IF;
            ID_rs2<=rs2_IF;
            ID_rs1<=rs1_IF;
            ID_funct3<=funct3_IF;
            ID_rd<=rd_IF;
            ID_opcode<=opcode_IF;
        end

        //ID
        EX_pc<=ID_pc;
        EX_inst<=ID_inst;
        EX_rs2<=ID_rs2;
        EX_rs1<=ID_rs1;
        EX_opcode<=ID_opcode;
        EX_rd<=ID_rd;
        EX_immediateValue_12<=immediateValue_12_ID;
        EX_immediateValue_20<=immediateValue_20_ID;
        EX_alusel<=alusel_ID;
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

        if(EX_opcode==7'b1100011 && EX_readData1==EX_readData2) begin
            MEM_branch<=1;
        end
        if(EX_opcode==7'b1101111)begin
            MEM_writedata<=EX_pc+4;
        end

        //MEM
        WB_inst<=MEM_inst;
        WB_opcode<=MEM_opcode;
        WB_rd<=MEM_rd;
        WB_result<=MEM_result;
        WB_writedata<=MEM_writedata;

        WB_memreadData<=memunit.readData;
        
        //WB
        
    end
endmodule