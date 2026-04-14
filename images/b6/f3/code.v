module bin_to_7seg (
    input [3:0] bin_in,
    output reg [6:0] seg_out
);

always @(*) begin
    case (bin_in)
        4'd0: seg_out = 7'b1111110;
        4'd1: seg_out = 7'b0110000;
        4'd2: seg_out = 7'b1101101;
        4'd3: seg_out = 7'b1111001;
        4'd4: seg_out = 7'b0110011;
        4'd5: seg_out = 7'b1011011;
        4'd6: seg_out = 7'b1011111;
        4'd7: seg_out = 7'b1110000;
        4'd8: seg_out = 7'b1111111;
        4'd9: seg_out = 7'b1111011;
        4'd10: seg_out = 7'b1110111;
        4'd11: seg_out = 7'b0011111;
        4'd12: seg_out = 7'b1001110;
        4'd13: seg_out = 7'b0111101;
        4'd14: seg_out = 7'b1001111;
        4'd15: seg_out = 7'b1000111;
        default: seg_out = 7'b0000000;
    endcase
end

endmodule