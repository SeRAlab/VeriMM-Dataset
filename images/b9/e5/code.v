module top_module(a,b,out);input [3:0] a,b;
output [7:0] out;
wire c1,c2,c3,c4,c5,c6;
assign out[0]=a[0]*b[0];
assign {c1,out[1]}=b[0]*a[1]+b[1]*a[0];
assign {c2,out[2]}=b[0]*a[2]+b[1]*a[1]+b[2]*a[0]+c1;
assign {c3,out[3]}=b[0]*a[3]+b[1]*a[2]+b[2]*a[1]+b[3]*a[0]+c2;
assign {c4,out[4]}=b[1]*a[3]+b[2]*a[2]+b[3]*a[1]+c3;
assign {c5,out[5]}=b[2]*a[3]+b[3]*a[2]+c4;
assign {c6,out[6]}=b[3]*a[3]+c5;
assign out[7]=c6;


endmodule