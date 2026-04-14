module top_module(clock, reset, addr, data_in, data_out);input  clock;
   input  reset;
   input  [3:0] addr;
   input  [7:0] data_in;
   output [7:0] data_out;

   


   reg    [7:0] mem [15:0]   ;
   reg    [7:0]	data_in_reg;
   reg    [3:0]	addr_reg;
   assign 	data_out = mem[addr_reg];

   always @(posedge clock)  begin
      mem[addr_reg] <= data_in_reg;
      data_in_reg   <= data_in;
      addr_reg      <= addr;
   end


endmodule