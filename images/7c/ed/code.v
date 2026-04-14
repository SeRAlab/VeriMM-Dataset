module top_module(a,b,eql,noteql);input [7:0]a,b;
output eql,noteql;
wire [7:0]exnor,s,bnot,b1,s1;
wire cout1,cout;

assign bnot=~b;
assign exnor=(a&b)|(~a)&(~b);

assign eql=&exnor;
assign noteql=~(eql&1);

endmodule