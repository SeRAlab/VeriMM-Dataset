module top_module(input a,input b, input ci, output c, output s);assign s = (a&b&ci)|(((~a&~b)|(~b&~ci)|(~a&~ci))&~(~a&~b&~ci));
assign c = ((a&b)|(a&ci))|(b&ci);
endmodule