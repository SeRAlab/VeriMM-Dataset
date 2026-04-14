module fft_8_point (
    input clk,
    input rst,
    input [255:0] data_in, // 8 complex numbers, each 32 bits
    output reg [255:0] data_out // 8 complex numbers, each 32 bits
);
    // Internal variables
    reg [255:0] fft_data; // To hold FFT processed data
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 256'b0;
        end else begin
            // Simple FFT implementation (for educational purposes)
            // Placeholder for actual FFT algorithm
            for (i = 0; i < 256; i = i + 1) begin
                fft_data[i] = data_in[i]; // Copying input to output for simplicity
            end
            data_out <= fft_data;
        end
    end
endmodule