module fibonacci_lfsr(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Set the LFSR to initial value 001
            q <= 3'b001;
        end else begin
            // Fibonacci LFSR with taps at positions 2 and 3
            q <= {q[1:0], q[2] ^ q[1]};
        end
    end

endmodule