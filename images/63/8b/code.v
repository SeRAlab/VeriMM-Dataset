module top_module(
  input [n-1:0] ctrl,
  input clk,           // Added clk as an input
  output [m-1:0] stored_val
);parameter n = 4; // number of control signals
parameter m = 8; // number of bits used to store control signals

reg [m-1:0] reg_val; // register to store control signals

initial begin
  reg_val = 8'b00000000; // default value for stored value
end

always @(posedge clk) begin
  reg_val <= {4'b0000, ctrl}; // update stored value when any control signal changes, adjusting to fit m bits
end

assign stored_val = reg_val; // output stored value

endmodule