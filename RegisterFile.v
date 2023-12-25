module RegisterFile(
    input wire clk,
    input wire writeEnable,
    input wire [4:0] writeReg,
    input wire [4:0] readReg1,
    input wire [4:0] readReg2,
    input wire [31:0] writeData,
    output wire [31:0] readData1,
    output wire [31:0] readData2
);

    reg [31:0] registers [0:31];
    integer i;
    initial begin
        for(i=0;i<32;i=i+1)
            registers[i]<=i;
    end

    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];

    always @(posedge clk) begin
        if (writeEnable) begin
            registers[writeReg] = writeData;
        end
    end
endmodule
