module top_module(
    input clk,          // Clocks are used in sequential circuits
    input reset,        // Synchronous active-high reset
    input d1, d2,       // Data inputs for the two D flip-flops
    input select,       // Select input to choose between D flip-flops
    output reg [3:0] q  // 4-bit output from the active D flip-flop
);reg [3:0] q1, q2;   // Output values of the two D flip-flops
    wire [3:0] sum;     // Output value of the adder

    // Instantiate the two D flip-flops with synchronous reset
    always @(negedge clk) begin
        if (reset) begin
            q1 <= 4'b0;
            q2 <= 4'b0;
        end else begin
            q1 <= {3'b0, d1};  // Store d1 in the least significant bit
            q2 <= {3'b0, d2};  // Store d2 in the least significant bit
        end
    end

    // Instantiate the 4-bit adder
    assign sum = q1 + q2;

    // Control logic to choose between the two flip-flop outputs
    always @(*) begin
        if (select) begin
            q <= q2;
        end else begin
            q <= q1;
        end
    end

endmodule