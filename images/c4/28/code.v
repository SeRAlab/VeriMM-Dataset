module memory (
  input [63:0] data,
  input [25:0] rdaddress,
  input rdclken,
  input [25:0] wraddress,
  input wrclock,
  input wren,
  output reg [63:0] q
);

  reg [63:0] mem_array [67108863:0];
  reg [25:0] read_address;
  
  always @(rdaddress)
    read_address <= rdaddress;

  always @(posedge wrclock)
    if (wren)
      mem_array[wraddress] <= data;

  always @(posedge rdclken)
    q <= mem_array[read_address];

endmodule