module top_module(input a, b, c, output w2);wire n, m, p;
    assign #2 w2 = m | p; 
    assign #3 m = a & b;
    assign #3 p = c & n;
    assign #6 n = ~b;endmodule