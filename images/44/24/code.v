module top_module(offset16,offset32);input [15:0]  offset16;
   output [31:0] offset32;

   assign offset32=offset16[15]?{14'h3fff,offset16,2'b00}:
                   {14'h0000,offset16,2'b00};

endmodule