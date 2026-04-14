module noise_suppression (
    input wire clk,
    input wire reset,
    input wire in_signal,
    output reg out_signal
);
    parameter THRESHOLD = 4; // Number of clock cycles to consider stable
    reg [1:0] state; // State to track input signal
    reg [3:0] counter; // Counter for stable input

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_signal <= 0;
            state <= 0;
            counter <= 0;
        end else begin
            if (in_signal == state[0]) begin
                counter <= counter + 1;
                if (counter >= THRESHOLD) begin
                    out_signal <= in_signal;
                end
            end else begin
                state <= {state[0], in_signal}; // Shift register
                counter <= 1; // Reset counter
            end
        end
    end
endmodule