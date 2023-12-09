module PC (
    input wire clk,
    input wire [11:0] branchAddress,
    input wire [19:0] jumpAddress,
    input wire branch,
    input wire jump,
    output reg [31:0] pc
);
initial begin
    pc = 32'b0;
end
    always @(posedge clk) begin
            // 默认情况下，递增 PC
            pc <= pc + 4;
            // 跳转指令时，使用 jumpAddress 更新 PC
            if (jump) begin
                pc <= pc + $signed({{12{jumpAddress[19]}}, jumpAddress});
            end;
            // 分支指令时，根据控制信号更新 PC
            if (branch) begin
                pc <= pc + $signed({{20{branchAddress[11]}}, branchAddress});
            end;
        end
endmodule
