module D_ff_with_ce_and_synch_reset_behavior(
    input D, Clk, reset, ce,
    output reg Q
);

always @(posedge Clk) begin
    if (reset) begin
        Q <= 0;
    end else if (ce) begin
        Q <= D;
    end
end

endmodule