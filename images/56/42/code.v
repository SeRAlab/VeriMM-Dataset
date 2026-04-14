module top_module(
    input [3:0] B,
    output reg [7:0] O
);always @(*)
begin
    case(B)
        4'b0001: O = 8'b00000001;
        4'b0010: O = 8'b00000010;
        4'b0100: O = 8'b00000100;
        4'b1000: O = 8'b00001000;
        default: O = 8'b00000000;
    endcase
end

endmodule