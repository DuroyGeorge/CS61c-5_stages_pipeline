module MemoryUnit (
    input wire clk,
    input wire [31:0] address,
    input wire [31:0] writeData,
    input wire memWrite, 
    output wire [31:0] readData
);

    reg [7:0] memory [0:1023]; 
    integer i;
    initial begin
        // Reset memory to initial state
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] <= 7'b0;
        end
    end
    assign readData = {memory[address+3],memory[address+2],memory[address+1],memory[address]};
    always @(posedge clk) begin
            if (memWrite) begin
                memory[address] <= writeData[7:0];
                memory[address+1]<=writeData[15:8];
                memory[address+2]<=writeData[23:16];
                memory[address+3]<=writeData[31:24];
            end
        end

endmodule
