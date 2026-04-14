module top_module(output s, co, input a, b, ci);assign s=a^b^ci;
assign co=(a&b)|(b&ci)|(ci&a);endmodule