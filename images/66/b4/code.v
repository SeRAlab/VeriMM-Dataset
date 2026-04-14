module top_module(
    input data_in,
    input shift,
    input clk,
    output reg q
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (shift) begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

assign q = shift_reg[0];

endmodule