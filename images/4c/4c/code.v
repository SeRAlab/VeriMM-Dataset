module top_module(
  input ld,
  output reg vd,
  output reg [7:0] d,
  output reg lz,
  input vz,
  input [7:0] z,
  output reg [7:0] size,
  input req_size,
  input [7:0] sizez,
  output reg sizelz
);always @(*) begin
    d = z;
    lz = ld;
    vd = vz;
    size = sizez;
    sizelz = req_size;
  end

endmodule