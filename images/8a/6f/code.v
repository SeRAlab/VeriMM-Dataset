module top_module(
    input [3:0] in_0,
    input [3:0] in_1,
    input [3:0] in_2,
    input [3:0] in_3,
    input [1:0] sel,
    input [3:0] in,
    input [1:0] shift,
    output reg [3:0] out
);// 4-to-1 multiplexer
always @*
begin
    case (sel)
        2'b00: out = in_0;
        2'b01: out = in_1;
        2'b10: out = in_2;
        2'b11: out = in_3;
    endcase
end

// 4-bit barrel shifter
always @*
begin
    case (shift)
        2'b00: out = in << 2;
        2'b01: out = in >> 2;
        2'b10: out = $signed(in) <<< 2;
        2'b11: out = $signed(in) >>> 2;
    endcase
end

endmodule