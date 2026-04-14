module top_module(D, sel, Q);input        [ 1:0] sel;          
   input        [15:0]   D;          
   output  reg  [ 3:0]   Q;          

   always @ (D, sel) begin
   
      case(sel)               
         2'b00:   Q = D[3:0];       
         2'b01:   Q = D[7:4];
         2'b10:   Q = D[11:8];
         2'b11:   Q = D[15:12];
         default: Q = D[3:0];
      endcase
   
   end

endmodule