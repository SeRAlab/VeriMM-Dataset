module top_module(
    input [3:0] A,
    input [1:0] S,
    output reg [3:0] X
);always @(*) begin
        case (S)
            2'b00: X = 4'b0000;
            2'b01: X = 4'b1111;
            2'b10: X = (A == 4'b1111) ? 4'b0000 : A;
            2'b11: X = (A == 4'b0000) ? 4'b1111 : A;
        endcase
    end

endmodule