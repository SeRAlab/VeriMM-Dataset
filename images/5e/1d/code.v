module top_module(output cout, output [3:0] sum,
                   input [3:0] a, b, cin);wire [3:0] gen, pro;
    genvar k;
    
    generate for (k = 0; k < 4; k = k + 1) begin: GLOOP
        assign gen[k] = a[k] & b[k];
        assign pro[k] = a[k] ^ b[k];
    end
    endgenerate
    
    wire g3, g2, g1, g0, p3, p2, p1, p0, c3, c2, c1, c0;
    
    assign {g3, g2, g1, g0} = gen;
    assign {p3, p2, p1, p0} = pro;
    
    
    assign c0 = g0 | (p0 & cin),
           c1 = g1 | (p1 & g0) | (p1 & p0 & cin),
           c2 = g2 | (p2 & p1) | (p2 & p1 & g0) | (p2 & p1 & g0 & cin),
           c3 = g3 | (p3 & p2) | (p3 & p2 & p1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & g0 & cin);
    
    assign sum = {p3, p2, p1, p0} ^ {c2, c1, c0, cin};
    
    assign cout = c3;endmodule