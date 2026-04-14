module top_module(
    input wire [1:0] mode,
    input wire [3:0] in,
    output reg [3:0] out
);always @(*) begin
    case(mode)
        2'b00: out = {in[2:0], 1'b0};
        2'b01: out = {1'b0, in[3:1]};
        2'b10: out = ~in;
        2'b11: out = in;
        default: out = 4'b0;
    endcase
end

endmodule