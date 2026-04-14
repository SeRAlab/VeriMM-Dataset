module top_module(
    input [1:0] sel,
    input en,
    output reg [15:0] out
);always @ (sel, en) begin
    case (sel)
        2'b00: out = en ? 16'b1111111111111110 : 16'b1111111111111111;
        2'b01: out = en ? 16'b1111111111111101 : 16'b1111111111111111;
        2'b10: out = en ? 16'b1111111111111011 : 16'b1111111111111111;
        2'b11: out = en ? 16'b1111111111110111 : 16'b1111111111111111;
        default: out = 16'b1111111111111111;
    endcase
end

endmodule