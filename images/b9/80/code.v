module top_module(
    input [3:0] binary_in,
    output reg [6:0] seg_out
);always @(*) begin
    case(binary_in)
        4'b0000: seg_out = 7'b0011111; //0
        4'b0001: seg_out = 7'b0000110; //1
        4'b0010: seg_out = 7'b0101101; //2
        4'b0011: seg_out = 7'b0100111; //3
        4'b0100: seg_out = 7'b0110010; //4
        4'b0101: seg_out = 7'b0110111; //5
        4'b0110: seg_out = 7'b0111111; //6
        4'b0111: seg_out = 7'b0000111; //7
        4'b1000: seg_out = 7'b0111111; //8
        4'b1001: seg_out = 7'b0110111; //9
        default: seg_out = 7'b1111111; //invalid input
    endcase
end

endmodule