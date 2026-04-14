module top_module(
  input [3:0] sel,
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  input [7:0] d,
  output reg [7:0] mux_out
);always @ (*) begin
  case(sel)
    4'b0000: mux_out = a;
    4'b0001: mux_out = b;
    4'b0010: mux_out = c;
    4'b0011: mux_out = d;
    4'b0100: mux_out = a;
    4'b0101: mux_out = b;
    4'b0110: mux_out = c;
    4'b0111: mux_out = d;
    4'b1000: mux_out = a;
    4'b1001: mux_out = b;
    4'b1010: mux_out = c;
    4'b1011: mux_out = d;
    4'b1100: mux_out = a;
    4'b1101: mux_out = b;
    4'b1110: mux_out = c;
    4'b1111: mux_out = d;
  endcase
end

endmodule