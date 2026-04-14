module top_module(
   
   dout,
   
   clk, we, en, addr, din
   );parameter WORD_WIDTH = 16;
   parameter ADDR_WIDTH = 10;


   input clk;
   input we;
   input en;
   input [9:0] addr;
   input [WORD_WIDTH-1:0] din;
   output [WORD_WIDTH-1:0] dout;
   reg [WORD_WIDTH-1:0]    RAM [(2<<ADDR_WIDTH)-1:0];
   reg [WORD_WIDTH-1:0]    dout;

   always @(posedge clk)
     begin
        if (en)
          begin
             if (we)
               begin
                  RAM[addr] <= din;
                  dout <= din;
               end
             else begin
               dout <= RAM[addr];

             end
          end
     end
endmodule