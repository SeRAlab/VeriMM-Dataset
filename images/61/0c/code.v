module top_module(
    input sys_clk,
    input sys_reset,
    output reg clk_out,
    output reg reset_out
);reg [3:0] counter;

always @(posedge sys_clk) begin
    if (counter == 4'd9) begin
        counter <= 4'd0;
        reset_out <= 1'b0;
    end else begin
        counter <= counter + 4'd1;
        reset_out <= 1'b1;
    end
    clk_out <= counter[0];
end

endmodule