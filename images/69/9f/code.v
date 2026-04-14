module top_module( input  CK, EN, output Q);reg gate;
   always@*
   if(!CK)
      gate <= EN;
   assign Q = CK & gate;endmodule