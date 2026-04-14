module binary_subtractor(
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output borrow_out
    );
    
    wire [3:0] borrow;
    
    assign borrow[0] = (~a[0] & b[0]);
    assign diff[0] = a[0] ^ b[0];
    
    assign borrow[1] = (~a[1] & b[1]) | (~a[1] & borrow[0]) | (b[1] & borrow[0]);
    assign diff[1] = a[1] ^ b[1] ^ borrow[0];
    
    assign borrow[2] = (~a[2] & b[2]) | (~a[2] & borrow[1]) | (b[2] & borrow[1]);
    assign diff[2] = a[2] ^ b[2] ^ borrow[1];
    
    assign borrow[3] = (~a[3] & b[3]) | (~a[3] & borrow[2]) | (b[3] & borrow[2]);
    assign diff[3] = a[3] ^ b[3] ^ borrow[2];
    
    assign borrow_out = borrow[3];
endmodule