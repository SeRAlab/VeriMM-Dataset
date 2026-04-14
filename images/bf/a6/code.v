module d_flip_flop(
    input  clk,
    input  reset,
    input  d,
    output q
);

reg q_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule