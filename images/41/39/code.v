module bin_to_bcd(
    input [3:0] binary,
    output reg [2:0] tens,
    output reg [3:0] ones
);

always @(*) begin
    case (binary)
        4'd0: begin tens = 3'd0; ones = 4'd0; end
        4'd1: begin tens = 3'd0; ones = 4'd1; end
        4'd2: begin tens = 3'd0; ones = 4'd2; end
        4'd3: begin tens = 3'd0; ones = 4'd3; end
        4'd4: begin tens = 3'd0; ones = 4'd4; end
        4'd5: begin tens = 3'd0; ones = 4'd5; end
        4'd6: begin tens = 3'd0; ones = 4'd6; end
        4'd7: begin tens = 3'd0; ones = 4'd7; end
        4'd8: begin tens = 3'd0; ones = 4'd8; end
        4'd9: begin tens = 3'd0; ones = 4'd9; end
        4'd10: begin tens = 3'd1; ones = 4'd0; end
        4'd11: begin tens = 3'd1; ones = 4'd1; end
        4'd12: begin tens = 3'd1; ones = 4'd2; end
        4'd13: begin tens = 3'd1; ones = 4'd3; end
        4'd14: begin tens = 3'd1; ones = 4'd4; end
        4'd15: begin tens = 3'd1; ones = 4'd5; end
        default: begin tens = 3'd0; ones = 4'd0; end
    endcase
end

endmodule