module top_module(
    input [15:0] in,
    output reg [15:0] out
);always @ (in) begin
        out[15:8] = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]}; // Upper 8 bits reversed
        out[7:0]  = {in[8], in[9], in[10], in[11], in[12], in[13], in[14], in[15]}; // Lower 8 bits reversed
    end

endmodule