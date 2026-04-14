module majority_function(
    input a,
    input b,
    input c,
    output majority);assign majority = (a & b) | (b & c) | (c & a);
endmodule