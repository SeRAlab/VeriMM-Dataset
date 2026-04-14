module d_ff (
    input d,
    input clk,
    input reset_n,
    output reg q
);always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule