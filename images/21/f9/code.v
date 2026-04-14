module noise_suppression (
    input wire clk,
    input wire rst,
    input wire noisy_signal,
    input wire threshold,
    output reg clean_signal
);
    reg [3:0] count;
    reg last_stable_value;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clean_signal <= 0;
            last_stable_value <= 0;
        end else begin
            if (noisy_signal == clean_signal) begin
                count <= 0; // Reset count if signal is stable
            end else begin
                count <= count + 1; // Increment count on noise
                if (count >= threshold) begin
                    clean_signal <= noisy_signal; // Update clean signal if threshold is reached
                    last_stable_value <= clean_signal;
                end else begin
                    clean_signal <= last_stable_value; // Maintain last stable value
                end
            end
        end
    end
endmodule