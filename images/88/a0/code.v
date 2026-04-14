module top_module(tval_o,ictmr_i,timer2_i,timer1_i);output [31:0] tval_o;
input [1:0] ictmr_i;
input [31:0] timer2_i;
input [31:0] timer1_i;

reg [31:0] tval_o;




always @(ictmr_i or timer2_i or timer1_i )
   begin

   case(ictmr_i )
      'h2 :
      begin
      tval_o  =(timer2_i );
      end

      default:
      begin

      tval_o  =(timer1_i );
      end


   endcase


   end

endmodule