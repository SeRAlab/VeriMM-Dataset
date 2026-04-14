module top_module(
    input clk,
    input SH_EN,
    input LD_EN,
    input [7:0] DATA_IN,
    output [7:0] SER_OUT,
    output [7:0] PAR_OUT
);reg [7:0] shift_reg [0:1];
reg [7:0] parallel_out;

always @(posedge clk) begin
    if (LD_EN) begin
        shift_reg[0] <= DATA_IN;
        shift_reg[1] <= DATA_IN;
    end else if (SH_EN) begin
        shift_reg[0] <= {shift_reg[0][6:0], shift_reg[1][7]};
        shift_reg[1] <= {shift_reg[1][6:0], shift_reg[0][7]};
    end
end

assign SER_OUT = shift_reg[0];
assign PAR_OUT = parallel_out;

always @(shift_reg[0], shift_reg[1]) begin
    parallel_out = shift_reg[1];
end

endmodule