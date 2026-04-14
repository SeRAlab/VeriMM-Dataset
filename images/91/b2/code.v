module top_module(CK, D, RN, Q);input  CK ;
input  D ;
input  RN ;
output [1:0] Q ;
reg [1:0] counter;

   always @(posedge CK) begin
       if (RN) begin
           counter <= 0;
       end else begin
           counter <= counter + 1;
       end
   end
   
   assign Q = counter;

endmodule