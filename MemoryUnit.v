module MemoryUnit (
    input wire clk,
    input wire [31:0] address,
    input wire [31:0] writeData,
    input wire memWrite, 
    output wire [31:0] readData
);

    reg [7:0] memory [0:1023]; 
    integer i;
    wire [31:0] temp;
    initial begin
        // Reset memory to initial state
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] <= 7'b0;
        end
    end
    assign temp =address<1024?address:0;
    assign readData = {memory[temp+3],memory[temp+2],memory[temp+1],memory[temp]};
    always @(posedge clk) begin
            if (memWrite) begin
                memory[temp] <= writeData[7:0];
                memory[temp+1]<=writeData[15:8];
                memory[temp+2]<=writeData[23:16];
                memory[temp+3]<=writeData[31:24];
            end
        end

endmodule
