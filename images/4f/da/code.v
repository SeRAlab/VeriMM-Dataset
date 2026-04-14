module Mux8to1 (
    input [7:0] in,
    input [2:0] sel,
    output out
);

    wire [3:0] mux_level1;
    wire [1:0] mux_level2;
    
    // First level of 2-to-1 multiplexers
    assign mux_level1[0] = sel[0] ? in[1] : in[0];
    assign mux_level1[1] = sel[0] ? in[3] : in[2];
    assign mux_level1[2] = sel[0] ? in[5] : in[4];
    assign mux_level1[3] = sel[0] ? in[7] : in[6];
    
    // Second level of 2-to-1 multiplexers
    assign mux_level2[0] = sel[1] ? mux_level1[1] : mux_level1[0];
    assign mux_level2[1] = sel[1] ? mux_level1[3] : mux_level1[2];
    
    // Third level of 2-to-1 multiplexer
    assign out = sel[2] ? mux_level2[1] : mux_level2[0];

endmodule