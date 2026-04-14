module top_module(clk, en, address, instr);input wire [30:0] address;   
   input wire         clk;
   input wire 	      en;

   output wire [31:0] instr;

   assign instr = (address == 31'h0000_0000) ? 32'h8000_0337 :
                  (address == 31'h0000_0004) ? 32'h0003_03E7 :
                  32'h0000_0000;
   
   
   
   
   
   
   
   
   
   
   
   
   

endmodule