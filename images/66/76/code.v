module top_module( 
    input wire [3:0] vec,
    output wire [3:0] outv,
    output wire o3,
    output wire o2,
    output wire o1,
    output wire o0,
    output wire parity );assign outv = vec;
    assign o3 = vec[3];
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];
    assign parity = vec[3] ^ vec[2] ^ vec[1] ^ vec[0];
    
endmodule