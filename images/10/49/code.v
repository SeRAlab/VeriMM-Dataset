module wifi_signal_monitor(
    input clk,
    input reset,
    input [7:0] signal_strength,
    output reg [7:0] average_strength
);
    reg [7:0] strength_buffer [0:4];
    integer i;
    reg [11:0] sum; // To hold the sum of signal strengths

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 5; i = i + 1) begin
                strength_buffer[i] <= 8'd0;
            end
            average_strength <= 8'd0;
            sum <= 12'd0;
        end else begin
            // Shift the buffer
            sum <= sum - strength_buffer[0] + signal_strength;
            for (i = 0; i < 4; i = i + 1) begin
                strength_buffer[i] <= strength_buffer[i + 1];
            end
            strength_buffer[4] <= signal_strength;

            // Calculate the average
            average_strength <= sum / 5;
        end
    end
endmodule