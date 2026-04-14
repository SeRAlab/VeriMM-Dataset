module d_ff_async_reset (D, clk, reset_n, Q);
   input D, clk, reset_n;
   output reg Q;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule