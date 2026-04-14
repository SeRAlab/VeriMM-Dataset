module top_module(
  input clock,
  input [31:0] data,
  input [4:0] rdaddress,
  input [4:0] wraddress,
  input wren,
  output reg [31:0] q
);reg [31:0] ram [0:31];

  always @(posedge clock) begin
    if (wren) begin
      ram[wraddress] <= data;
    end
    q <= ram[rdaddress];
  end

endmodule