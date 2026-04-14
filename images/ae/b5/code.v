module top_module(
    input parallel_load,
    input reset,
    input shift_left_clk,
    input shift_right_clk,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] shift_reg;

always @(posedge shift_left_clk or posedge shift_right_clk or posedge parallel_load or posedge reset) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else if (parallel_load) begin
        shift_reg <= data_in;
    end else if (shift_left_clk) begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end else if (shift_right_clk) begin
        shift_reg <= {shift_reg[0], shift_reg[3:1]};
    end
end

assign data_out = shift_reg;

endmodule