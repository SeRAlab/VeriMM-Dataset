module top_module(
    input [3:0] A,
    input [3:0] B,
    input cin,
    output reg [3:0] S,
    output reg cout
);always @(*) begin
        S = A + B + cin;
        cout = (A + B + cin > 15) ? 1'b1 : 1'b0;
    end

endmodule