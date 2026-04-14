module top_module(
  input  wire           clock,
  input  wire [  7-1:0] wraddress,
  input  wire           wren,
  input  wire [ 32-1:0] data,
  input  wire [  7-1:0] rdaddress,
  output reg  [ 32-1:0] q
);reg [32-1:0] mem [0:128-1];


always @ (posedge clock) begin
  if (wren) mem[wraddress] <= #1 data;
  q <= #1 mem[rdaddress];
end

endmodule