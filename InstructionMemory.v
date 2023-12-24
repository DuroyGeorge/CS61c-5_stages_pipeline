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
    // Add
    memory[0] <= 8'h33; 
    memory[1] <= 8'h84;
    memory[2] <= 8'h62;
    memory[3] <= 8'h00;
    //0000000 00110
    // LW
    memory[4] <= 8'h83; 
    memory[5] <= 8'h24;
    memory[6] <= 8'h84;
    memory[7] <= 8'h00;

    // or
    memory[8] <= 8'h33; 
    memory[9] <= 8'hEE;
    memory[10] <= 8'h54;
    memory[11] <= 8'h00;

    //and
    memory[12] <= 8'hB3; 
    memory[13] <= 8'hFE;
    memory[14] <= 8'h64;
    memory[15] <= 8'h00;

    //sll
    memory[16] <= 8'h33; 
    memory[17] <= 8'h92;
    memory[18] <= 8'h62;
    memory[19] <= 8'h00;

    //addi
    memory[20] <= 8'h93;
    memory[21] <= 8'h82;
    memory[22] <= 8'h12;
    memory[23] <= 8'h00;
    //0000000 00001 00101 000 00101 0010011

    //beq
    memory[24] <= 8'h63;
    memory[25] <= 8'h8F;
    memory[26] <= 8'h62;
    memory[27] <= 8'h00;
    // 0000000 00110 00101 000 11110 1100011

    // sub
    memory[28] <= 8'h23;
    memory[29] <= 8'h03;
    memory[30] <= 8'h44;
    memory[31] <= 8'h00;
    // 0000000 00100 01000 000 00110 0100011

    //xor
    memory[32] <= 8'hA3;
    memory[33] <= 8'h4F;
    memory[34] <= 8'hC4;
    memory[35] <= 8'h01;
    // 0000000 11100 01000 100 11111 0100011

    //or
    memory[36] <= 8'h23;
    memory[37] <= 8'hEF;
    memory[38] <= 8'h82;
    memory[39] <= 8'h00;
    // 0000000 01000 00101 110 11110 0100011

    //sub
    memory[54] <= 8'h23;
    memory[55] <= 8'h03;
    memory[56] <= 8'h44;
    memory[57] <= 8'h00;


    //xor
    memory[58] <= 8'hA3;
    memory[59] <= 8'h4F;
    memory[60] <= 8'hC4;
    memory[61] <= 8'h01;


    //SW
    memory[62] <= 8'h23;
    memory[63] <= 8'h20;
    memory[64] <= 8'h04;
    memory[65] <= 8'h00;
    // 0000000 00000 01000 010 00000 0100011

    //jal
    memory[66] <= 8'h6F;
    memory[67] <= 8'hF8;
    memory[68] <= 8'hFF;
    memory[69] <= 8'hFB;
    // 1 1111011111 1 11111111 10000 1101111
end


        assign instruction[7:0] = memory[address];
        assign instruction[15:8] = memory[address+1];
        assign instruction[23:16] = memory[address+2];
        assign instruction[31:24] = memory[address+3];

endmodule