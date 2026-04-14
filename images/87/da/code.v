module top_module(select,data_i00,data_i01,data_o);parameter Size = 8;

   input wire [('d1) - ('b1):0] select;
   input wire [(Size) - ('b1):0] data_i00;
   input wire [(Size) - ('b1):0] data_i01;

   output reg [(Size) - ('b1):0] data_o;

   always @ (select or data_i00 or data_i01) begin
     case (select)
       'b0:data_o = data_i00;
       'b1:data_o = data_i01;
     endcase 
   end
endmodule