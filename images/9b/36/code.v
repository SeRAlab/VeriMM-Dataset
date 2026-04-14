module top_module(
  input clk_in,
  input data_in,
  output [m-1:0] ctrl_out
);parameter m = 4; // number of control signals
  
  reg [m-1:0] ctrl_reg; // register bank for control signals
  
  always @(posedge clk_in) begin
    ctrl_reg <= data_in; // update register bank with new data on clock edge
  end
  
  assign ctrl_out = ctrl_reg; // output control signals from register bank
  
endmodule