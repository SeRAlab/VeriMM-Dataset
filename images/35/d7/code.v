module DWT (
    input clk,
    input [3:0] sample,
    output reg [3:0] lpf_out,
    output reg [3:0] hpf_out
);
    reg [3:0] prev_samples [0:3]; // Store the last 4 samples
    integer i;
    
    always @(posedge clk) begin
        // Shift the previous samples
        prev_samples[3] <= prev_samples[2];
        prev_samples[2] <= prev_samples[1];
        prev_samples[1] <= prev_samples[0];
        prev_samples[0] <= sample;

        // Perform LPF and HPF calculations
        lpf_out <= (prev_samples[0] + prev_samples[1] + prev_samples[2] + prev_samples[3]) >> 2; // Average
        hpf_out <= (prev_samples[0] - prev_samples[1] + prev_samples[2] - prev_samples[3]) >> 2; // Difference
    end
endmodule