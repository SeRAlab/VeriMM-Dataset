module d_flip_flop_comb (
    input clk,
    input d,
    output reg q );

    always @ (posedge clk)
        q <= d;

endmodule