module goertzel(
    input clk,
    input reset, 
    input [15:0] sample, 
    input start, 
    output reg detected
);
    parameter TARGET_FREQ = 100; // Example frequency
    parameter SAMPLE_RATE = 1000; // Example sample rate
    parameter N = 256; // Number of samples to process
    
    reg [15:0] s_prev, s_prev2;
    reg [7:0] count;
    reg [31:0] coeff;
    reg processing;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            s_prev <= 0;
            s_prev2 <= 0;
            count <= 0;
            detected <= 0;
            processing <= 0;
        end else if (start && !processing) begin
            processing <= 1;
            count <= 0;
            coeff <= 2 * $cos(2 * 3.14159265359 * TARGET_FREQ / SAMPLE_RATE);
            detected <= 0;
        end else if (processing) begin
            if (count < N) begin
                s_prev <= sample + coeff * s_prev;
                s_prev2 <= s_prev;
                count <= count + 1;
            end else begin
                processing <= 0;
                // Calculate the magnitude of the result
                if ((s_prev * s_prev) + (s_prev2 * s_prev2) - (s_prev * coeff * s_prev2) > 10000) begin
                    detected <= 1; // Detected the frequency
                end else begin
                    detected <= 0; // Not detected
                end
            end
        end
    end
endmodule