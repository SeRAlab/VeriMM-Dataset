module top_module(
        rdaddress,
        clock,
        wraddress,
        data,
        wren,
        q);parameter AC_ROM_DATA_WIDTH = "";
parameter AC_ROM_ADDRESS_WIDTH = ""; 


input   [(AC_ROM_ADDRESS_WIDTH-1):0]  rdaddress;
input     clock;
input [(AC_ROM_ADDRESS_WIDTH-1):0] wraddress;
input [(AC_ROM_DATA_WIDTH-1):0] data;
input wren;
output reg [(AC_ROM_DATA_WIDTH-1):0]  q;

reg [(AC_ROM_DATA_WIDTH-1):0] ac_mem[(2**AC_ROM_ADDRESS_WIDTH-1):0];

always @(posedge clock)

begin
  if(wren)
  ac_mem[wraddress] <= data;
  q <= ac_mem[rdaddress];

end



endmodule