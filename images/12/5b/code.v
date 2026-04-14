module sample_rate_converter (
    input clk,
    input rst,
    input enable,
    input [7:0] in_sample,
    output reg [7:0] out_sample,
    output reg out_valid
);
    reg [1:0] count;
    reg [7:0] sample_buffer [0:3]; // Buffer for 4 samples
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            out_valid <= 0;
            out_sample <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                sample_buffer[i] <= 0;
            end
        end else if (enable) begin
            sample_buffer[count] <= in_sample; // Store incoming sample
            count <= count + 1;
            if (count == 3) begin
                out_sample <= (sample_buffer[0] + sample_buffer[1] + sample_buffer[2] + sample_buffer[3]) >> 2; // Average the samples
                out_valid <= 1; // Signal that output is valid
                count <= 0; // Reset count for next set of samples
            end else begin
                out_valid <= 0; // Output not valid until enough samples are collected
            end
        end
    end
endmodule