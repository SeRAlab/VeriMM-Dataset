module top_module(
input [3:0]ina,
input [3:0]inb,
input cin,
output [3:0]sum,
output cout
    );assign {cout,sum}=ina+inb+cin;
endmodule