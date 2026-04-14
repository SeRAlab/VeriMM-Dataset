module fft_32_point (
    input clk,
    input rst,
    input valid_in,
    input [31:0] data_in,
    output reg valid_out,
    output reg [31:0] data_out
);
    reg [31:0] data_buffer [0:31];
    reg [4:0] count;
    reg processing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            processing <= 0;
            valid_out <= 0;
        end else begin
            if (valid_in && count < 32) begin
                data_buffer[count] <= data_in;
                count <= count + 1;
                processing <= (count == 31);
            end
            
            if (processing) begin
                // Perform FFT operation on data_buffer (simplified for this example)
                data_out <= data_buffer[0]; // Placeholder for actual FFT result
                valid_out <= 1;
                processing <= 0; // Reset processing
                count <= 0; // Reset count for next input
            end else begin
                valid_out <= 0; // Output is not valid
            end
        end
    end
endmodule