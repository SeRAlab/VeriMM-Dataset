module top_module(
input [7:0] in1,
input [7:0] in2,
input [7:0] in3,
input [7:0] in4,
input [7:0] in5,
input [7:0] in6,
input [7:0] in7,
input [7:0] in8,
input [2:0] choose,
input sel,
output reg [15:0] out
);reg [7:0] sel_in1, sel_in2, sel_in3, sel_in4;

always @(*) begin
    sel_in1 = {in1, in2};
    sel_in2 = {in3, in4};
    sel_in3 = {in5, in6};
    sel_in4 = {in7, in8};
    case(sel)
        1'b0: begin
            case(choose)
                3'b000: out = {sel_in1};
                3'b001: out = {sel_in1[15:8], sel_in1[7:0]};
                3'b010: out = {sel_in2};
                3'b011: out = {sel_in2[15:8], sel_in2[7:0]};
                3'b100: out = {sel_in3};
                3'b101: out = {sel_in3[15:8], sel_in3[7:0]};
                3'b110: out = {sel_in4};
                3'b111: out = {sel_in4[15:8], sel_in4[7:0]};
                default: out = 16'b0;
            endcase
        end
        1'b1: begin
            case(choose)
                3'b000: out = {in1, in2};
                3'b001: out = {in1, in2[7:0], in3};
                3'b010: out = {in2[7:0], in3, in4};
                3'b011: out = {in3, in4[7:0], in5};
                3'b100: out = {in4[7:0], in5, in6};
                3'b101: out = {in5, in6[7:0], in7};
                3'b110: out = {in6[7:0], in7, in8};
                3'b111: out = {in7, in8[7:0]};
                default: out = 16'b0;
            endcase
        end
        default: out = 16'b0;
    endcase
end

endmodule