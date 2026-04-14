module fib_lfsr(
    input clk,
    input reset_n,
    output reg [5:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous active low reset
            q <= 6'b000001;
        end else begin
            // Fibonacci LFSR logic
            q <= {q[4:0], q[5] ^ q[3]};
        end
    end

endmodule