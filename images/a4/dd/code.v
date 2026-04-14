module top_module(
output reg [3:0] anode,
output [6:0] cathode,
input [3:0] btn

    );assign cathode = 7'b0000000;
 always @(*)
   begin
     case (btn)
       4'b0001: anode = 4'b1110;
       4'b0010: anode = 4'b1101;
       4'b0100: anode = 4'b1011;
       4'b1000: anode = 4'b0111;
       default : anode = 4'b1111; 
     endcase
   end
endmodule