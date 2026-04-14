module top_module(
  input [3:0] value,
  input ctrl,
  output reg out
);reg [3:0] resistance;
  
  always @ (ctrl, value) begin
    resistance = value * ctrl;
  end
  
  assign out = resistance;
  
endmodule