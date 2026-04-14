module top_module(input [7:0] a, b,
            output [7:0] c, d, e, f, g, h, i, j, k);assign c = a & b;               
    assign d = a | b;               
    assign e = a ^ b;               
    assign f = ~a;                  
    assign g = {a[3:0], b[3:0]};    
    assign h = a >> 3;              
    assign i = &b;                  
    assign j = (a > b) ? a : b;     
    assign k = a - b;               
endmodule