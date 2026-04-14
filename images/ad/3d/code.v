module decoder3to8 (
  input [2:0] in,
  input enable,
  output reg [7:0] out
);always_comb begin
    if (enable)
        out = 8'b1 << in;
    else
        out = 8'b0;
end

endmodule