module ALU (
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    input wire [2:0] alusel,
    output reg [31:0] result
);

always @* begin
    // Use operand2 directly if it is not an immediate value
    // Otherwise, use the immediate value with sign extension
    // ALU operations
    case (alusel)
        3'b000: result = operand1 + operand2; // ADD
        3'b010: result = operand1 - operand2; // SUB
        3'b101: result = operand1 >>> operand2[4:0]; // SRL
        3'b011: result = $signed(operand1) >>> operand2[4:0]; // SRA (with sign extension)
        3'b001: result = operand1 << operand2[4:0]; // SLL
        3'b100: result = operand1 ^ operand2; // XOR
        3'b110: result = operand1 | operand2; // OR
        3'b111: result = operand1 & operand2; // AND
        default: result = 32'bz;
    endcase
end

endmodule
