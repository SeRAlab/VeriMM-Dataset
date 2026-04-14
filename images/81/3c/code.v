module top_module(
    input clk,
    input d,
    output reg q
);// Local signals
    reg buf_q; // Changed buf_q to reg type as we're storing the output of DFF here
    reg prev_d; // Added a signal to hold previous state of d

    // D flip-flop behavior implemented with a simple always block
    always @(posedge clk) begin
        buf_q <= d; // Store input d at the positive edge of clk
    end

    // Generate pulse whenever input signal changes from 0 to 1
    always @(posedge clk) begin
        if (d == 1 && prev_d == 0) begin // Detect rising edge of d
            q <= 1; // Generate pulse
        end else begin
            q <= 0; // Reset pulse
        end
        prev_d <= d; // Update previous state of d
    end

endmodule