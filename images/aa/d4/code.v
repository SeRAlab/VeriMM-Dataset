module top_module(
    input [3:0] i_num,
    output reg [1:0] o_out
);always @(*) begin
    case (i_num)
        4'b0000, 4'b0001, 4'b0010:
            o_out = 2'b00;
        4'b0011, 4'b0100, 4'b0101, 4'b0110:
            o_out = 2'b01;
        4'b0111, 4'b1000, 4'b1001, 4'b1010:
            o_out = 2'b10;
        default:
            o_out = 2'b11;
    endcase
end

endmodule