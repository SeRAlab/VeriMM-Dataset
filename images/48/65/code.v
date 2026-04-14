module top_module(
        rdaddress,
        clock,
        data,
        wraddress,
        wren,
        q);parameter INST_ROM_DATA_WIDTH = "";
parameter INST_ROM_ADDRESS_WIDTH = "";

input [(INST_ROM_ADDRESS_WIDTH-1):0]  rdaddress;
input     clock;
input [(INST_ROM_ADDRESS_WIDTH-1):0] wraddress;
input [(INST_ROM_DATA_WIDTH-1):0] data;
input wren; 
output reg [(INST_ROM_DATA_WIDTH-1):0]  q;

reg [(INST_ROM_DATA_WIDTH-1):0] inst_mem[(2**INST_ROM_ADDRESS_WIDTH-1):0];

always @(posedge clock)

begin
  if (wren)
  inst_mem[wraddress]<= data;
  q <= inst_mem[rdaddress];

end



endmodule