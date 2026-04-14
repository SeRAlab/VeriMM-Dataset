module top_module(
    input a, b, c,
    output w, x, y, z
    );assign w = ~(a & b & c);
    assign x = ~(a & b & ~c);
    assign y = ~(a & ~b & c);
    assign z = ~(a & ~b & ~c);
    
endmodule