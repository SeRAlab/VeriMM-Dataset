module fft_8point (
    input clk,
    input rst,
    input [255:0] in_data, // 8 complex numbers (8*32 bits)
    output reg [255:0] out_data // 8 complex outputs
);
    // FFT algorithm implementation here (simplified for brevity)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data <= 256'b0;
        end else begin
            // FFT computation logic here (stub)
            out_data <= in_data; // Placeholder
        end
    end
endmodule