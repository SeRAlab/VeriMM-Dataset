module top_module(
  input  wire           clock,
  input  wire [  9-1:0] wraddress,
  input  wire           wren,
  input  wire [  2-1:0] byteena_a,
  input  wire [ 16-1:0] data,
  input  wire [  9-1:0] rdaddress,
  output reg  [ 16-1:0] q
);reg [8-1:0] mem0 [0:512-1];
reg [8-1:0] mem1 [0:512-1];


always @ (posedge clock) begin
  if (wren && byteena_a[0]) mem0[wraddress] <= #1 data[ 8-1:0];
  if (wren && byteena_a[1]) mem1[wraddress] <= #1 data[16-1:8];
  q[ 8-1:0] <= #1 mem0[rdaddress];
  q[16-1:8] <= #1 mem1[rdaddress];
end

endmodule