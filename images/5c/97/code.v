module top_module(
    input wire a,
    input wire b,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0
);wire xor_out;
    
    // XOR module
    assign xor_out = a ^ b;
    
    // Since xor_out is a single bit, we need to assign it correctly
    assign o2 = 1'b0; // xorr_out does not have a 3rd bit
    assign o1 = 1'b0; // xorr_out does not have a 2nd bit
    assign o0 = xor_out; // assignment of the single bit
    assign outv = {o2, o1, o0};
    
endmodule