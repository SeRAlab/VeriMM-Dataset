module top_module(
    input clk,
    input reset,
    input d,
    input a,
    input b,
    output reg out_comb_logic,
    output q
);reg [2:0] shift_reg;
reg xor_out;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b0;
        xor_out <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[1:0], d};
        xor_out <= a ^ b;
    end
end

assign out_comb_logic = shift_reg[0] ^ xor_out;
assign q = shift_reg[0];

endmodule