module top_module(
    input clk,
    input SER_IN,
    input SH_EN,
    output [3:0] PAR_OUT
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (SH_EN) begin
        shift_reg <= {shift_reg[2:0], SER_IN};
    end else begin
        shift_reg <= shift_reg;
    end
end

assign PAR_OUT = shift_reg;

endmodule