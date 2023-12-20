module ControlUnit (
    input wire [31:0] instruction,
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    input wire [4:0] rs2,
    input wire [4:0] rs1,
    input wire [4:0] rd,
    output reg load,
    output reg store,
    output reg jump,
    output reg [2:0] alusel,
    output reg [11:0] immediateValue_12,
    output reg [19:0] immediateValue_20
);

initial begin
    load=0;
    store=0;
    jump=0;
    immediateValue_12=12'b0;
    immediateValue_20=12'b0;
end
    // ALU operation mapping
    always @* begin
        case (opcode) 
        7'b0110011: begin // R-type instructions
               jump = 0; 
               immediateValue_12=12'b0;immediateValue_20=20'b0;
               load=1;store=0;
               case(funct3)
                3'b000: begin
                    if(funct7==7'b0000000)begin
                        alusel=3'b000;
                    end
                    else begin
                        alusel=3'b010;
                    end
                end
                3'b001: begin
                    alusel=3'b100;
                end
                3'b100: begin
                    alusel=3'b110;
                end
                3'b101:begin
                    if(funct7==7'b0000000)begin
                        alusel=3'b101;
                    end
                    else begin
                        alusel=3'b011;
                    end
                end
                3'b110:begin
                    alusel=3'b110;
                end
                3'b111:begin
                    alusel=3'b111;
                end
        endcase
        end
        7'b0010011: begin // I-type instructions
            case (funct3)
                3'b000: begin
                    jump = 0; 
                    immediateValue_12 = {funct7[6:0], rs2[4:0]}; // addi
                    immediateValue_20=20'b0;
                    load=1;store=0;
                    alusel=3'b000;
                end

                // Add more I-type instructions as needed
                // ...
                default: begin
                jump = 0; immediateValue_12=12'b0;immediateValue_20=20'b0;load=0;store=0;
                end
            endcase
        end
        7'b0000011: begin // Load instructions
            jump = 0; 
            immediateValue_12={funct7,rs2};immediateValue_20=20'b0; // lw
            load=1;store=0;
            alusel=3'b000;
        end
        7'b0100011: begin // Store instructions
            jump = 0; 
            immediateValue_20={funct7,rd};immediateValue_12=12'b0; // sw
            store = 1;load=0;
            alusel=3'b000;
        end
        7'b1100011: begin // B-type instructions (Branch)
            jump = 0; 
            immediateValue_12={instruction[31],instruction[7],instruction[30:25],instruction[11:8]};immediateValue_20=20'b0; // beq
            load=0;store=0;
            alusel=3'b000;
            // Add more B-type instructions as needed
            // ...
        end
        7'b1101111: begin // J-type instructions (Jump)
            jump = 1; 
            immediateValue_20={instruction[31],instruction[19:12],instruction[20],instruction[30:21]};immediateValue_12=12'b0; // j
            load=1;store=0;
            alusel=3'b000;
            // Add more J-type instructions as needed
            // ...
        end
        default: begin // NOP instruction
            jump = 0; 
            immediateValue_12=12'b0;immediateValue_20=20'b0;
            load=0;store=0;
            alusel=3'b0;
        end
    endcase
        end
endmodule