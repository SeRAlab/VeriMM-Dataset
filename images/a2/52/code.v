module top_module(In0,In1,In2,In3,In4,In5,Sel,Out);parameter N=1;
input[N-1:0] In0,In1,In2,In3,In4,In5;
input[2:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==3'b000)?In0:
           (Sel==3'b001)?In1:
           (Sel==3'b010)?In2:
           (Sel==3'b011)?In3:
           (Sel==3'b100)?In4:
           (Sel==3'b101)?In5:1'd0;endmodule