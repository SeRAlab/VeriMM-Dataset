module fft_butterfly (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire signed [15:0] a_real,
    input wire signed [15:0] a_imag,
    input wire signed [15:0] b_real,
    input wire signed [15:0] b_imag,
    output reg signed [15:0] out_a_real,
    output reg signed [15:0] out_a_imag,
    output reg signed [15:0] out_b_real,
    output reg signed [15:0] out_b_imag,
    output reg valid_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_a_real <= 0;
            out_a_imag <= 0;
            out_b_real <= 0;
            out_b_imag <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            // Butterfly operation: 
            // out_a = a + b
            // out_b = a - b
            out_a_real <= a_real + b_real;
            out_a_imag <= a_imag + b_imag;
            out_b_real <= a_real - b_real;
            out_b_imag <= a_imag - b_imag;
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule