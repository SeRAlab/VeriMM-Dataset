module top_module(
    input [3:0] num,
    output reg [4:0] result
);always @(*) begin
    case(num)
        4'b0001: result = 5'b0010;
        4'b0010: result = 5'b0100;
        4'b0011: result = 5'b0100;
        4'b0100: result = 5'b1000;
        4'b0101: result = 5'b1000;
        4'b0110: result = 5'b1000;
        4'b0111: result = 5'b1000;
        4'b1000: result = 5'b1000;
        4'b1001: result = 5'b10000;
        4'b1010: result = 5'b10000;
        4'b1011: result = 5'b10000;
        4'b1100: result = 5'b10000;
        4'b1101: result = 5'b10000;
        4'b1110: result = 5'b10000;
        4'b1111: result = 5'b10000;
    endcase
end

endmodule