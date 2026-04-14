module top_module(a,b,fc1,fc2,fc3);input [3:0] a,b;
output fc1,fc2,fc3;
wire c,d,e;


assign fc1=((a[0]~^b[0])&(a[1]~^b[1])&(a[2]~^b[2])&(a[3]~^b[3]));

assign c=(a[1]~^b[1]);
assign d=(a[2]~^b[2]);
assign e=(a[3]~^b[3]);

assign fc2=((a[3]&~b[3])|(e&a[2]&~b[2])|(e&a[1]&~b[1]&d)|(e&d&c&a[0]&~b[0]));

assign fc3=(~fc2&~fc1);

endmodule