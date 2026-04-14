module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] S,
    output reg [3:0] out
);reg [1:0] sel;

always @(*) begin
    if (A > B && A > C && A > D) sel = 2'b00;
    else if (B > C && B > D) sel = 2'b01;
    else if (C > D) sel = 2'b10;
    else sel = 2'b11;
end

always @(sel or A or B or C or D) begin
    case (sel)
        2'b00: out = A;
        2'b01: out = B;
        2'b10: out = C;
        2'b11: out = D;
    endcase
end

endmodule