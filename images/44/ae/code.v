module top_module(
    input [7:0]exponent,
    input clk, clear, load,
    output reg [7:0]saved_exp
    );always @(posedge clk)
        if(clear)
            saved_exp <= 8'b0;
        else if(load)
            saved_exp <= exponent;

endmodule