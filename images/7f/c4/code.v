module top_module(a,b,lin,ein,gin,lout,eout,gout);input a,b,lin,ein,gin;

output lout,eout,gout;
wire lout,eout,gout;

assign lout=(ein&(~a&b))|(lin);
assign gout=(ein&(a&(~b)))|(gin);
assign eout=((a&b)|((~a)&(~b)))&ein;
endmodule