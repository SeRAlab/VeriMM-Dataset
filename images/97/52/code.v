module top_module(
    input [4:0] A,B,
    input enable,
    output reg[4:0] O
);always @* begin
        if (enable) O <= B;
        else O <= A;
    end

endmodule