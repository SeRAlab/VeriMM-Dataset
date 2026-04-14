module top_module(
    input wire [1:0] x,
    input wire [1:0] y,
    output wire answer

);wire p0,p1,p2,p3;

assign p0= (~x[1]&~y[1])&(~x[0]&~y[0]);
assign p1= (~x[1]&~y[1])&(x[0]&y[0]);
assign p2= (x[1]&y[1])&(~x[0]&~y[0]);
assign p3= (x[1]&y[1])&(x[0]&y[0]);
assign answer= p0|p1|p2|p3;

endmodule