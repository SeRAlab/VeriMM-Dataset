module top_module(s,a,b,chave);output s;

input a;
input b;
input chave;

wire temp1;
wire temp2;
wire temp3;
wire temp4;

assign temp1 = a&b;
assign temp2 = a|b;
assign temp3 = temp1&chave;
assign temp4 = temp2&(~chave);
assign s = temp3 | temp4;endmodule