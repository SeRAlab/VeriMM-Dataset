module top_module(
    input                    rst_n,
    input                    clk,        
    input                    cen55,
    input             [ 7:0] tl,         
    input      signed [15:0] pcm_in,
    output reg signed [15:0] pcm_out
);wire signed [15:0] factor = {8'd0, tl};
wire signed [31:0] pcm_mul = pcm_in * factor; 

always @(posedge clk) if(cen55)
    pcm_out <= pcm_mul[23:8];

endmodule