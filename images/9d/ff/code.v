module top_module(
    input [3:0] input_val,
    output reg [15:0] bcd_val
);always @(*) begin
    case(input_val)
        4'b0000: bcd_val = 16'b0000000000000000;
        4'b0001: bcd_val = 16'b0000000000000001;
        4'b0010: bcd_val = 16'b0000000000000010;
        4'b0011: bcd_val = 16'b0000000000000011;
        4'b0100: bcd_val = 16'b0000000000000100;
        4'b0101: bcd_val = 16'b0000000000000101;
        4'b0110: bcd_val = 16'b0000000000000110;
        4'b0111: bcd_val = 16'b0000000000000111;
        4'b1000: bcd_val = 16'b0000000000010000;
        4'b1001: bcd_val = 16'b0000000000010001;
        default: bcd_val = 16'b0000000000000000;
    endcase
end

endmodule