module top_module(
    input [3:0] inclk,
    input [1:0] clkselect,
    output reg outclk // Changed from wire to reg
);wire [3:0] sel_inclk;
assign sel_inclk[0] = inclk[0];
assign sel_inclk[1] = inclk[1];
assign sel_inclk[2] = inclk[2];
assign sel_inclk[3] = inclk[3];

always @(*) begin
    case(clkselect)
        2'b00: outclk = sel_inclk[0];
        2'b01: outclk = sel_inclk[1];
        2'b10: outclk = sel_inclk[2];
        2'b11: outclk = sel_inclk[3];
        default: outclk = 1'b0;
    endcase
end

endmodule