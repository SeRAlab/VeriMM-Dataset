module top_module(bp,cprdt,gin,ci,control,cout);output cout;
input bp,cprdt,gin,ci,control;

assign cout = cprdt&(~bp) | (~control)&bp&gin | control&bp&ci;endmodule