module top_module(
    input serial_in,
    input shift,
    input reset,
    input clk,
    output [7:0] parallel_out
);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else if (shift) begin
        shift_reg <= {shift_reg[6:0], serial_in};
    end
end

assign parallel_out = shift_reg;

endmodule