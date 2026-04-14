module DWT (
    input clk,
    input rst,
    input [7:0] x, // input signal
    input valid_in,
    output reg [7:0] approx_out, // approximation output
    output reg [7:0] detail_out, // detail output
    output reg valid_out
);

    reg [7:0] x_buffer [0:1]; // buffer for input samples
    reg [1:0] count; // counts number of input samples

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            valid_out <= 0;
            approx_out <= 0;
            detail_out <= 0;
        end else if (valid_in) begin
            // Store input samples in buffer
            x_buffer[count] <= x;
            count <= count + 1;

            if (count == 1) begin
                // Compute DWT
                approx_out <= (x_buffer[0] + x_buffer[1]) >> 1; // Approximation
                detail_out <= (x_buffer[0] - x_buffer[1]) >> 1; // Detail
                valid_out <= 1;
            end
            
            if (count == 2) begin
                count <= 0; // Reset count after processing two samples
                valid_out <= 0; // Reset valid output
            end
        end
    end
endmodule