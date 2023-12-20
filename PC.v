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
        if(nop) begin
        end
        else begin
            // 默认情况下，递增 PC
            pc <= pc + 4;
            // 跳转指令时，使用 jumpAddress 更新 PC
            if (jump||branch) begin
                pc <= newpc;
            end;
        end
        end
endmodule
