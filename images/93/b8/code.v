module decoder3to8 (
  input [2:0] in,
  input enable,
  output reg [7:0] out
);

  always @(*) begin
    if (enable)
      out = 8'b00000001 << in;
    else
      out = 8'b00000000;
  end

endmodule