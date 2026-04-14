module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input Select,
    output [3:0] Sum,
    output reg [7:0] priority_out
);// 4-bit ripple carry adder
    assign Sum = Select ? 4'b0000 : A + B;

    // 3-to-8 priority encoder
    always @(*) begin
        case ({C[3], C[2], C[1], C[0]})
            4'b1000: priority_out = 8'b11111110;
            4'b0100: priority_out = 8'b11111101;
            4'b0010: priority_out = 8'b11111011;
            4'b0001: priority_out = 8'b11110111;
            4'b1100: priority_out = 8'b11111100;
            4'b1010: priority_out = 8'b11111010;
            4'b1001: priority_out = 8'b11110110;
            4'b0110: priority_out = 8'b11111001;
            4'b0101: priority_out = 8'b11110101;
            4'b0011: priority_out = 8'b11110011;
            4'b1110: priority_out = 8'b11110010;
            4'b1101: priority_out = 8'b11100110;
            4'b1011: priority_out = 8'b11010110;
            4'b0111: priority_out = 8'b10110110;
            default: priority_out = 8'b11111111;
        endcase
    end

endmodule