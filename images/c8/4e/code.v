module d_ff_async_reset (
    input D, RESET_B, CLK,
    output Q
);

reg Q;

always @(posedge CLK, negedge RESET_B) begin
    if (!RESET_B) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule