module top_module(
    input [3:0] B,
    output reg [3:0] N
);always @(*) begin
        case(B)
            4'b0000: N = 4'b0001;
            4'b0001: N = 4'b0010;
            4'b0010: N = 4'b0011;
            4'b0011: N = 4'b0100;
            4'b0100: N = 4'b0101;
            4'b0101: N = 4'b0110;
            4'b0110: N = 4'b0111;
            4'b0111: N = 4'b1000;
            4'b1000: N = 4'b1001;
            4'b1001: N = 4'b1010;
            4'b1010: N = 4'b1011;
            4'b1011: N = 4'b1100;
            4'b1100: N = 4'b1101;
            4'b1101: N = 4'b1110;
            4'b1110: N = 4'b1111;
            4'b1111: N = 4'b0000;
            default: N = 4'b0000;
        endcase
    end

endmodule