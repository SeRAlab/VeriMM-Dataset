module top_module(
    input clk,
    input reset,
    input [3:0] data_in,
    input enable,
    output [3:0] data_out,
    output parity,
    output overflow,
    output underflow
);reg [3:0] data_out_reg;
reg parity_reg;
reg overflow_reg;
reg underflow_reg;

always @(posedge clk) begin
    if (reset) begin
        data_out_reg <= 4'b0000;
        parity_reg <= 1'b0;
        overflow_reg <= 1'b0;
        underflow_reg <= 1'b0;
    end else if (enable) begin
        data_out_reg <= data_out_reg + data_in;
        parity_reg <= ~parity_reg;
        overflow_reg <= (data_out_reg + data_in) > 4'b1111;
        underflow_reg <= (data_out_reg + data_in) < 4'b0000;
    end
end

assign data_out = data_out_reg;
assign parity = parity_reg;
assign overflow = overflow_reg;
assign underflow = underflow_reg;

endmodule