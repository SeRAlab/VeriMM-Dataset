module top_module(a,b,select,result);input [63:0] a;
    input [63:0] b;
    input select;
    output[63:0] result;
	
     assign result = (select)? b : a;
endmodule