module top_module(
    input [3:0] DIN,
    input [1:0] SHIFT,
    output reg [3:0] DOUT
);always @(*) begin
    case (SHIFT)
        2'b00: DOUT = DIN;
        2'b01: DOUT = {DIN[2:0], DIN[3]};
        2'b10: DOUT = {DIN[1:0], DIN[3:2]};
        2'b11: DOUT = {DIN[0], DIN[3:1]};
    endcase
end

endmodule