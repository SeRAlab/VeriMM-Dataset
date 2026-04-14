module brent_kung_adder (  
    input [3:0] a,  
    input [3:0] b,  
    output [3:0] sum,  
    output carry_out  
);  
    wire [3:0] p; // propagate  
    wire [3:0] g; // generate  
    wire [3:0] c; // carry bits  

    // Generate and propagate signals  
    assign p = a ^ b;  
    assign g = a & b;  

    // Carry bit calculations using Brent-Kung structure  
    assign c[0] = g[0];  
    assign c[1] = g[1] | (p[1] & g[0]);  
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);  
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);  

    // Calculate the sum  
    assign sum = p ^ c;  
    assign carry_out = c[3];  
endmodule