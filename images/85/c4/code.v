module top_module(
  // inputs:
  data,
  rdaddress,
  rdclken,
  wraddress,
  wrclock,
  wren,

  // outputs:
  q
);output [15:0] q;
  input [15:0] data;
  input [24:0] rdaddress;
  input rdclken;
  input [24:0] wraddress;
  input wrclock;
  input wren;

  reg [15:0] mem_array[33554431:0];
  reg [24:0] read_address;
  wire [15:0] q;

  always @(*) begin
    if (rdclken) begin
      read_address <= rdaddress;
    end
  end

  assign q = mem_array[read_address];

  always @(posedge wrclock) begin
    if (wren) begin
      mem_array[wraddress] <= data;
    end
  end

endmodule