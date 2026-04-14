module top_module (
    input [3:0] bcd,
    output reg [6:0] segments
);
    always @(*) begin
        case (bcd)
            4'd0: segments = 7'b0111111;
            4'd1: segments = 7'b0000110;
            4'd2: segments = 7'b1011011;
            4'd3: segments = 7'b1001111;
            4'd4: segments = 7'b1100110;
            4'd5: segments = 7'b1101101;
            4'd6: segments = 7'b1111101;
            4'd7: segments = 7'b0000111;
            4'd8: segments = 7'b1111111;
            4'd9: segments = 7'b1101111;
            default: segments = 7'b0000000;
        endcase
    end
endmodule