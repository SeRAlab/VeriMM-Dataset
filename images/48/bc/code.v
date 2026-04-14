module top_module(
    input [1:0] A, B, C, D,
    output reg [1:0] X
);always @(*)
begin
    case ({A,B,C,D})
        4'b0000: X = 2'b00;
        4'b0001: X = 2'b01;
        4'b0010: X = 2'b01;
        4'b0011: X = 2'b00;
        4'b0100: X = 2'b01;
        4'b0101: X = 2'b00;
        4'b0110: X = 2'b00;
        4'b0111: X = 2'b01;
        4'b1000: X = 2'b01;
        4'b1001: X = 2'b00;
        4'b1010: X = 2'b00;
        4'b1011: X = 2'b01;
        4'b1100: X = 2'b00;
        4'b1101: X = 2'b01;
        4'b1110: X = 2'b01;
        4'b1111: X = 2'b00;
    endcase
end

endmodule