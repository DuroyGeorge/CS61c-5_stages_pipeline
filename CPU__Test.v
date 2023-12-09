`timescale 1ns / 1ps

module tb_CPU;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg clk;

  // Instantiate the CPU module
  CPU uut (
    .clk(clk)
  );

  // Clock generation
  always #((CLK_PERIOD / 2)) clk = ~clk;

  // Initial block
  initial begin
    // Initialize signals
    clk = 0;
    #500 $finish;
  end

endmodule
