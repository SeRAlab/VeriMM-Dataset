module top_module(
    input [3:0] vin,
    output reg vout
);reg [3:0] stage1_out;
reg [3:0] stage2_out;
reg [3:0] stage3_out;

always @(*) begin
    stage1_out = vin;
    stage2_out = stage1_out;
    stage3_out = stage2_out;
end

always @(*) begin
    case(stage3_out)
        4'b0000: vout = 0;
        4'b0001: vout = 0.333;
        4'b0010: vout = 0.667;
        4'b0011: vout = 1;
        4'b0100: vout = 1.333;
        4'b0101: vout = 1.667;
        4'b0110: vout = 2;
        4'b0111: vout = 2.333;
        4'b1000: vout = 2.667;
        4'b1001: vout = 3;
        4'b1010: vout = 3.333;
        4'b1011: vout = 3.667;
        4'b1100: vout = 4;
        4'b1101: vout = 4.333;
        4'b1110: vout = 4.667;
        4'b1111: vout = 5;
    endcase
end

endmodule