module audio_sample_rate_converter (
    input clk,
    input rst,
    input [15:0] audio_in, // 16-bit audio input
    output reg [15:0] audio_out, // 16-bit audio output
    output reg valid_out // Indicates when output is valid
);
    reg [1:0] count; // Counter for downsampling
    reg [15:0] sample_buffer; // Buffer to hold the sample

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            audio_out <= 0;
            valid_out <= 0;
        end else begin
            if (count == 1) begin // Every two input samples
                audio_out <= audio_in; // Output the sample
                valid_out <= 1; // Mark the output as valid
                count <= 0; // Reset counter
            end else begin
                valid_out <= 0; // Mark output as invalid
                count <= count + 1; // Increment counter
            end
        end
    end
endmodule