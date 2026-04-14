module top_module(
    input [3:0] binary,
    output reg [7:0] excess_3
);always @(*) begin
    case (binary)
        4'd0: excess_3 = 8'b0011_0011;
        4'd1: excess_3 = 8'b0011_0100;
        4'd2: excess_3 = 8'b0011_0101;
        4'd3: excess_3 = 8'b0011_0110;
        4'd4: excess_3 = 8'b0011_0111;
        4'd5: excess_3 = 8'b0011_1000;
        4'd6: excess_3 = 8'b0011_1001;
        4'd7: excess_3 = 8'b0011_1010;
        4'd8: excess_3 = 8'b0011_1011;
        4'd9: excess_3 = 8'b0011_1100;
        4'd10: excess_3 = 8'b0011_1101;
        4'd11: excess_3 = 8'b0011_1110;
        4'd12: excess_3 = 8'b0011_1111;
        4'd13: excess_3 = 8'b0100_0000;
        4'd14: excess_3 = 8'b0100_0001;
        4'd15: excess_3 = 8'b0100_0010;
        default: excess_3 = 8'b0000_0000;
    endcase
end

endmodule