module top_module(input [7:0] d, input s, r, clk, output [7:0] q);reg [7:0] state;
  always @ (posedge clk)  state = r ? 8'b0 : (s ? d : state);
  assign q = state;
endmodule