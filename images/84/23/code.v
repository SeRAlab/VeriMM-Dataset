module top_module(
    input [3:0] in,
    input [1:0] ctrl,
    output reg [3:0] out
);always @(*) begin
    case(ctrl)
        2'b00: out = {in[2:0], 1'b0};
        2'b01: out = {in[1:0], 2'b00};
        2'b10: out = {1'b0, in[3:1]};
        2'b11: out = {2'b00, in[3:2]};
        default: out = 4'b0;
    endcase
end

endmodule