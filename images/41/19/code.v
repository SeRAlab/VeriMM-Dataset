module top_module(
    input a,
    input b,
    input c,
    input d,
    output y
);wire a_and_b, a_and_c, a_and_d, b_and_c, b_and_d, c_and_d;
    wire three_or_four_ones, two_ones, one_one;
    
    assign a_and_b = a & b;
    assign a_and_c = a & c;
    assign a_and_d = a & d;
    assign b_and_c = b & c;
    assign b_and_d = b & d;
    assign c_and_d = c & d;
    
    assign three_or_four_ones = (a & b & c) | (a & b & d) | (a & c & d) | (b & c & d) | (a & b & c & d);
    assign two_ones = (a & b & ~c & ~d) | (a & c & ~b & ~d) | (a & d & ~b & ~c) | (b & c & ~a & ~d) | (b & d & ~a & ~c) | (c & d & ~a & ~b);
    assign one_one = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d);
    
    assign y = three_or_four_ones | one_one;
    assign y = y & ~two_ones;
    
endmodule