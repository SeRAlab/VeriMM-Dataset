module top_module(
    input [3:0] ic0,
    input [3:0] ic1,
    input [3:0] ic2,
    input [3:0] ic3,
    input is0,
    input is1,
    output reg [3:0] oz
    );always @ (*)
         begin
           case({is1,is0})
           2'b00: oz = ic0;
           2'b01: oz = ic1;
           2'b10: oz = ic2;
           2'b11: oz = ic3;
           default: oz = 1'bx; 
           endcase
         end
endmodule