module top_module(
    input clk,
    input reset,
    input start,
    input signed [15:0] a_real,
    input signed [15:0] a_imag,
    input signed [15:0] b_real,
    input signed [15:0] b_imag,
    output reg signed [31:0] result_real,
    output reg signed [31:0] result_imag,
    output reg done
    );reg signed [31:0] temp_real;
    reg signed [31:0] temp_imag;
    reg signed [31:0] result;
    
    always @(posedge clk) begin
        if (reset) begin
            result_real <= 0;
            result_imag <= 0;
            done <= 0;
        end else begin
            if (start) begin
                temp_real <= (a_real * b_real - a_imag * b_imag) >> 16;
                temp_imag <= (a_real * b_imag + a_imag * b_real) >> 16;
                result <= temp_real + temp_imag * 2'b10;
                result_real <= result[31:16];
                result_imag <= result[15:0];
                done <= 1;
            end else if (done) begin
                done <= 0;
            end
        end
    end
    
endmodule