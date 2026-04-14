module top_module(
    input [9:0] a,
    input [9:0] b,
    output [19:0] p
);wire [9:0] a_low, a_high, b_low, b_high;
    wire [19:0] p_intermediate;
    
    // Split the input numbers into two halves
    assign a_low = a[4:0];
    assign a_high = a[9:5];
    assign b_low = b[4:0];
    assign b_high = b[9:5];
    
    // Multiply the two halves using shift registers and adders
    wire [19:0] p_low;
    wire [19:0] p_high;
    assign p_low = {a_low, 5'b0} * {b_low, 5'b0};
    assign p_high = {a_high, 5'b0} * {b_high, 5'b0};
    
    // Add the outputs of the two halves using the adders
    wire [19:0] p_add1;
    wire [19:0] p_add2;
    assign p_add1 = p_low + p_high;
    assign p_add2 = p_add1 + {a_low + a_high, b_low + b_high};
    
    // Output the final product
    assign p = p_add2;
    
endmodule