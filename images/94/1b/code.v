module top_module(
    input [3:0] input_value,
    output reg [6:0] output_value
);always @(*) begin
    case(input_value)
        4'b0000: output_value = 7'b0000000;
        4'b0001: output_value = 7'b0000001;
        4'b0010: output_value = 7'b0000010;
        4'b0011: output_value = 7'b0000011;
        4'b0100: output_value = 7'b0000100;
        4'b0101: output_value = 7'b0000101;
        4'b0110: output_value = 7'b0000110;
        4'b0111: output_value = 7'b0000111;
        4'b1000: output_value = 7'b0001000;
        4'b1001: output_value = 7'b0001001;
        4'b1010: output_value = 7'b0001010;
        4'b1011: output_value = 7'b0001011;
        4'b1100: output_value = 7'b0001100;
        4'b1101: output_value = 7'b0001101;
        4'b1110: output_value = 7'b0001110;
        4'b1111: output_value = 7'b0001111;
    endcase
end

endmodule