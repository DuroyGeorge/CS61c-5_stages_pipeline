module InstructionMemory (
    input wire [31:0] address,
    output wire [31:0] instruction
);

    reg [7:0] memory [0:1023]; // Assuming 1024 words of 32-bit instructions

    // Initial instructions (replace with actual instructions)
    integer i;
    initial begin
        // Reset memory to initial state
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 7'b0;
        end
        memory[4] <= 8'h13;
        memory[5] <= 8'h00;
        memory[6] <= 8'h10;
        memory[7] <= 8'h00;

        memory[8] <= 8'h13;
        memory[9] <= 8'h83;
        memory[10]<= 8'h22;
        memory[11] <= 8'h00;

        memory[12] <= 8'h13;
        memory[13] <= 8'h83;
        memory[14] <= 8'h23;
        memory[15] <= 8'h00;

        memory[20] <= 8'h00;
        memory[21] <= 8'h00;
        memory[22] <= 8'h00;
        memory[23] <= 8'h00;
    end
        assign instruction[7:0] = memory[address];
        assign instruction[15:8] = memory[address+1];
        assign instruction[23:16] = memory[address+2];
        assign instruction[31:24] = memory[address+3];

endmodule