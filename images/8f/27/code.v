module top_module(In0,In1,In2,Sel,Out);parameter N=1;
input[N-1:0] In0,In1,In2;
input[1:0] Sel;
output[N-1:0] Out;
assign Out=(Sel==2'b00)?In0:
           (Sel==2'b01)?In1:
           (Sel==2'b10)?In2:1'd0;endmodule