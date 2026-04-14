module binary_to_7segment(
    input [2:0] binary,
    output reg [6:0] segment);always @(*) begin
    case (binary)
        3'd0: segment = 7'b0111111;
        3'd1: segment = 7'b0000110;
        3'd2: segment = 7'b1011011;
        3'd3: segment = 7'b1001111;
        3'd4: segment = 7'b1100110;
        3'd5: segment = 7'b1101101;
        3'd6: segment = 7'b1111101;
        3'd7: segment = 7'b0000111;
        default: segment = 7'b0000000;
    endcase
end
endmodule