module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    output reg [1:0] out
);always @(*) begin
        if (A > B && A > C && A > D)
            out = 2'b00;
        else if (B > A && B > C && B > D)
            out = 2'b01;
        else if (C > A && C > B && C > D)
            out = 2'b10;
        else
            out = 2'b11;
    end

endmodule