module vec_scal_converter (
  input [3:0] vec,
  output reg [1:0] outv,
  output reg [1:0] outs
);

  always @(*) begin
    outv = vec[3:2];
    outs = vec[1:0];
  end

endmodule
