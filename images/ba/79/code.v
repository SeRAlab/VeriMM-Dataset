module top_module(
    input [15:0]a,b,
    output [15:0]y_add,y_sub,y_mul,y_div
    );assign y_add = a+b;
    assign y_sub = a-b;
    assign y_mul = a*b;
    assign y_div = a/b;
    
endmodule