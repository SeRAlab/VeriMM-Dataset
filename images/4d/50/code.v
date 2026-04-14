module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output reg y);assign y = (a & b & ~c & ~d) | (a & b & c & ~d) | (a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & ~b & c & d);

endmodule