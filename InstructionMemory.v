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
        memory[i] = 8'b0;
    end

    // Add instructions
    memory[0] <= 8'h33; 
    memory[1] <= 8'h84;
    memory[2] <= 8'hA2;
    memory[3] <= 8'h00;


    memory[4] <= 8'h83; 
    memory[5] <= 8'h24;
    memory[6] <= 8'h84;
    memory[7] <= 8'h00;


    memory[8] <= 8'h33; 
    memory[9] <= 8'hEE;
    memory[10] <= 8'h54;
    memory[11] <= 8'h00;


    memory[12] <= 8'h5B; 
    memory[13] <= 8'hFD;
    memory[14] <= 8'h93;
    memory[15] <= 8'h00;


    memory[16] <= 8'hB3; 
    memory[17] <= 8'h12;
    memory[18] <= 8'h53;
    memory[19] <= 8'h00;
end


        assign instruction[7:0] = memory[address];
        assign instruction[15:8] = memory[address+1];
        assign instruction[23:16] = memory[address+2];
        assign instruction[31:24] = memory[address+3];

endmodule