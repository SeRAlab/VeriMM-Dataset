module top_module(
    input [3:0] binary_in,
    output reg [7:0] bcd_out
);reg [3:0] bcd_ones;
reg [3:0] bcd_tens;

always @(*) begin
    case (binary_in)
        4'b0000: bcd_ones = 4'b0000;
        4'b0001: bcd_ones = 4'b0001;
        4'b0010: bcd_ones = 4'b0010;
        4'b0011: bcd_ones = 4'b0011;
        4'b0100: bcd_ones = 4'b0100;
        4'b0101: bcd_ones = 4'b0101;
        4'b0110: bcd_ones = 4'b0110;
        4'b0111: bcd_ones = 4'b0111;
        4'b1000: bcd_ones = 4'b1000;
        4'b1001: bcd_ones = 4'b1001;
        default: bcd_ones = 4'b0000;
    endcase
end

always @(*) begin
    case (binary_in)
        4'b0000: bcd_tens = 4'b0000;
        4'b0001: bcd_tens = 4'b0000;
        4'b0010: bcd_tens = 4'b0000;
        4'b0011: bcd_tens = 4'b0000;
        4'b0100: bcd_tens = 4'b0000;
        4'b0101: bcd_tens = 4'b0000;
        4'b0110: bcd_tens = 4'b0000;
        4'b0111: bcd_tens = 4'b0000;
        4'b1000: bcd_tens = 4'b0000;
        4'b1001: bcd_tens = 4'b0000;
        default: bcd_tens = 4'b0000;
    endcase
end

always @(*) begin
    bcd_out = {bcd_tens, bcd_ones};
end

endmodule