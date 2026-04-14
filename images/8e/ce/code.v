module top_module(
    input [1:0] sel,
    input [3:0] din,
    output reg dout
);always @(*) begin
    case(sel)
        2'b00: dout = din[0];
        2'b01: dout = din[1];
        2'b10: dout = din[2];
        2'b11: dout = din[3];
    endcase
end

endmodule