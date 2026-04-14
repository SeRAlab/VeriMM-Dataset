module top_module(
    input [31:0] rx_a,
    input [31:0] rx_b,
    input [31:0] rx_c,
    output reg [31:0] tx_sum,
    output reg tx_carry
);always @(*)
begin
    tx_sum = rx_a + rx_b + rx_c;
    tx_carry = (tx_sum > 32'hFFFFFFFF) ? 1 : 0;
end

endmodule