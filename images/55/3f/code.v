module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input d,          // Input for the shift register
    input pause,      // Input to pause the counter
    input resume,     // Input to resume the counter
    output reg [3:0] q    // Output from the decade counter
);reg [2:0] shift_reg;
    reg [4:0] sum;
    reg counter_enable;

    // Shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 0;
        end else begin
            shift_reg <= {shift_reg[1:0], d};
        end
    end

    // Decade counter
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (counter_enable) begin
            q <= q + 1;
        end
    end

    // Functional module
    always @(posedge clk) begin
        if (reset) begin
            sum <= 0;
        end else begin
            sum <= shift_reg + q;
        end
    end

    // Control module
    always @(posedge clk) begin
        if (reset) begin
            counter_enable <= 1;
        end else if (sum >= 12) begin
            counter_enable <= 0;
        end else if (pause) begin
            counter_enable <= 0;
        end else if (resume) begin
            counter_enable <= 1;
        end
    end

endmodule