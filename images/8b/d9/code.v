module top_module(
    input clk,
    input reset,
    input enable,
    input parallel_load,
    input [31:0] data_in,
    output reg data_out
);reg [31:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
            data_out <= 0;
        end else if (parallel_load) begin
            shift_reg <= data_in;
            data_out <= shift_reg[31];
        end else if (enable) begin
            shift_reg <= {shift_reg[30:0], data_out};
            data_out <= shift_reg[31];
        end else begin
            data_out <= shift_reg[31];
        end
    end

endmodule