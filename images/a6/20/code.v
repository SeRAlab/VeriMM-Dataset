module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input in,         // Input signal to be delayed
    input [3:0] delay, // Number of clock cycles to delay the input signal
    output [3:0] q    // 4-bit output from the functional module
);reg [3:0] counter = 4'd0;
    reg [3:0] shift_reg = 4'd0;
    wire [3:0] delayed_out;
    wire [3:0] counter_out;

    // Shift register with delay
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'd0;
        end else begin
            shift_reg <= {in, shift_reg[3:1]};
        end
    end

    assign delayed_out = shift_reg[delay];

    // State machine counter
    always @(posedge clk) begin
        if (reset) begin
            counter <= 4'd0;
        end else begin
            counter <= counter + 1;
        end
    end

    assign counter_out = counter;

    // Functional module
    assign q = delayed_out | counter_out;

endmodule