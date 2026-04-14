module top_module(
    clk,
    reset,
    A,
    X
);parameter DELAY_CYCLES = 10; // replace with actual delay time in clock cycles

    input clk;
    input reset;
    input A;
    output reg X; // change output from wire to reg

    reg [DELAY_CYCLES-1:0] delay_reg;
    wire delayed_A;

    assign delayed_A = delay_reg[DELAY_CYCLES-1];

    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= {DELAY_CYCLES{1'b0}};
            X <= 1'b0; // Initialize output to zero on reset
        end else begin
            delay_reg <= {delay_reg[DELAY_CYCLES-2:0], A};
            X <= delayed_A; // Update output on clock edge
        end
    end

    // Removed the unknown module instantiation
    // You can instead implement a logic or another delay methodology if needed

endmodule