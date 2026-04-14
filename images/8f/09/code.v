module top_module(
    input wire [3:0] vec,
    output wire [3:0] outv,
    output wire [1:0] outv1,
    output wire [1:0] outv2,
    output wire o3,
    output wire o2,
    output wire o1,
    output wire o0 );assign outv = vec;
    assign outv1 = vec[3:2];
    assign outv2 = vec[1:0];
    assign o3 = vec[3];
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule