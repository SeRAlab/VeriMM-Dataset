module mux_2to1(
  input [7:0] in0,
  input [7:0] in1,
  input sel,
  output reg [7:0] out
);

always @(*) begin
  out = sel ? in1 : in0;
end

endmodule