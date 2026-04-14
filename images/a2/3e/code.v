module top_module(
    input [7:0] exponent_in,
    input [8:0] val1,
    input [8:0] val2,
    output reg [7:0] exponent_out
    );always @(*)
    begin
        if (val2[8] == 0)
            exponent_out = exponent_in - val2[7:0];
        else
            exponent_out = exponent_in + val2[7:0];
    end
endmodule