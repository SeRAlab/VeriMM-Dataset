module top_module(a,b,c
    );input wire [31:0]a,b;
output reg [31:0]c;
always @* c=a+b;

endmodule