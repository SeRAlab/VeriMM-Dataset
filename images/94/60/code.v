module top_module(
    input clk,
    input SH_EN,
    input LD_EN,
    input [7:0] DATA_IN,
    output [7:0] SER_OUT,
    output [7:0] PAR_OUT
);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (LD_EN) begin
        shift_reg <= DATA_IN;
    end else if (SH_EN) begin
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

assign PAR_OUT = shift_reg;
assign SER_OUT = shift_reg[0];

endmodule