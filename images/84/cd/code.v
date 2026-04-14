module top_module(word, key, str);input  [127:0] word, key;
output [127:0] str;
assign str = word ^ key;endmodule