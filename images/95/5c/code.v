module top_module(
    input [3:0] in,
    input [1:0] sel,
    output reg [3:0] out
);always @(*) begin
    case(sel)
        2'b00: out = {in[3:2], 2'b00};
        2'b01: out = in & 4'b1100;
        2'b10: out = in | 4'b0011;
        2'b11: out = in ^ 4'b1010;
    endcase
end

endmodule