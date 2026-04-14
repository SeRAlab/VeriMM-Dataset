module mux_4to1_8bit(
    input wire [1:0] sel,
    input wire [7:0] in0,
    input wire [7:0] in1,
    input wire [7:0] in2,
    input wire [7:0] in3,
    output reg [7:0] out
    );

always @(*) begin
    case(sel)
        2'b00: out = in0;
        2'b01: out = in1;
        2'b10: out = in2;
        2'b11: out = in3;
        default: out = 8'b0;
    endcase
end

endmodule