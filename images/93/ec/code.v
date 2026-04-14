module top_module(
    input a, 
    input b,
    output wire out
);wire not_a, not_b, temp1, temp2;
    
    assign not_a = ~a;
    assign not_b = ~b;
    assign temp1 = not_a ^ b;
    assign temp2 = a ^ not_b;
    assign out = ~(temp1 ^ temp2);
    
endmodule