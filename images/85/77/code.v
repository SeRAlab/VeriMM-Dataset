module top_module(
  input clk, // clock signal
  input [15:0] data, // input data signal
  output reg [15:0] acc // accumulated value
);// Define a register to store the accumulated value
  reg [15:0] acc_reg;

  // Reset the accumulator to zero on power up or when a reset signal is received
  initial begin
    acc_reg <= 16'd0;
  end

  // On the rising edge of the clock signal, add the input data value to the previous accumulated value
  always @(posedge clk) begin
    acc_reg <= acc_reg + data;
  end

  // Output the accumulated value on each clock cycle
  assign acc = acc_reg;

endmodule