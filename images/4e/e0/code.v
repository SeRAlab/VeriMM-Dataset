module top_module (
    input clk,
    input reset,
    output reg [5:0] q
);

    // Fibonacci LFSR logic
    always @(posedge clk) begin
        if (reset)
            q <= 6'b000001;
        else
            q <= {q[4:0], q[5] ^ q[4]};
    end

endmodule