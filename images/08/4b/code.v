module butterworth_filter (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] sample_in,
    output reg [7:0] filtered_out
);
    reg [7:0] samples [0:4]; // Store the last five samples
    reg [2:0] index; // Index for storing samples
    reg [15:0] sum; // Accumulator for the filter output

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 0;
            filtered_out <= 0;
            sum <= 0;
        end else if (enable) begin
            // Store the new sample
            samples[index] <= sample_in;
            index <= (index + 1) % 5; // Wrap around index

            // Calculate the output as the average of the last five samples
            sum = samples[0] + samples[1] + samples[2] + samples[3] + samples[4];
            filtered_out <= sum / 5; // Average the samples
        end
    end
endmodule