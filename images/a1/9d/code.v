module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    initial begin
        // Initial seed value
        q = 5'b10101;
    end

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Set to predefined seed value
            q <= 5'b10101;
        end else begin
            // Generate pseudo-random sequence
            q <= {q[3:0], q[4] ^ q[2]};
        end
    end

endmodule