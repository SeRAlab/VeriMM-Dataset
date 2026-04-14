module top_module(
    input clk,
    input in,
    output reg out
);

    reg in_d; // Delayed version of the input signal

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        out <= in & ~in_d; // Detect the rising edge
        in_d <= in; // Update the delayed input signal
    end

endmodule