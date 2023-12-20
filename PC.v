module PC (
    input wire clk,
    input wire [31:0] newpc,
    input wire branch,
    input wire jump,
    input wire nop,
    output reg [31:0] pc
);
initial begin
    pc = 32'b0;
end
    always @(posedge clk) begin
        if(nop)begin
        end
        else begin
            pc <= pc + 4;
            if (jump||branch) begin
                pc <= newpc;
            end;
        end
    end
endmodule
