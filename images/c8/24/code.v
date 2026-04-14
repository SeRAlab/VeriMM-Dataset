module clock_gate (
    input clk,
    input enable,
    output reg clk_out
);

always @(posedge clk) begin
    if (enable) begin
        clk_out <= 1'b1;
    end else begin
        clk_out <= 1'b0;
    end
end

endmodule