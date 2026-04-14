module top_module(
    input clk,
    input serial_in,
    input reset,
    output reg [3:0] parallel_out
);reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {shift_reg[2:0], serial_in};
    end
end

always @(negedge clk) begin
    parallel_out <= shift_reg;
end

endmodule