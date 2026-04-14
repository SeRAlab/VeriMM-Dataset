module async_reset_ff(
    input clk,
    input reset,
    input d,
    output reg q
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule