module crossbar_4x4
(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [1:0] sel0,
    input [1:0] sel1,
    input [1:0] sel2,
    input [1:0] sel3,
    output reg [3:0] out0,
    output reg [3:0] out1,
    output reg [3:0] out2,
    output reg [3:0] out3
);

always @(*) begin
    case (sel0)
        2'b00: out0 = in0;
        2'b01: out0 = in1;
        2'b10: out0 = in2;
        2'b11: out0 = in3;
        default: out0 = 4'b0000;
    endcase
end

always @(*) begin
    case (sel1)
        2'b00: out1 = in0;
        2'b01: out1 = in1;
        2'b10: out1 = in2;
        2'b11: out1 = in3;
        default: out1 = 4'b0000;
    endcase
end

always @(*) begin
    case (sel2)
        2'b00: out2 = in0;
        2'b01: out2 = in1;
        2'b10: out2 = in2;
        2'b11: out2 = in3;
        default: out2 = 4'b0000;
    endcase
end

always @(*) begin
    case (sel3)
        2'b00: out3 = in0;
        2'b01: out3 = in1;
        2'b10: out3 = in2;
        2'b11: out3 = in3;
        default: out3 = 4'b0000;
    endcase
end

endmodule