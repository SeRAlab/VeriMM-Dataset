module top_module(
    input [3:0] binary,
    output [3:0] gray
);wire [2:0] xor_out;
    
    assign xor_out[0] = binary[1] ^ binary[0];
    assign xor_out[1] = binary[2] ^ binary[1];
    assign xor_out[2] = binary[3] ^ binary[2];
    
    assign gray[0] = binary[0];
    assign gray[1] = xor_out[0];
    assign gray[2] = xor_out[1];
    assign gray[3] = xor_out[2];
    
endmodule