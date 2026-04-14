module fft_4point (
    input clk,
    input rst,
    input [15:0] x0_real, x0_imag,
    input [15:0] x1_real, x1_imag,
    input [15:0] x2_real, x2_imag,
    input [15:0] x3_real, x3_imag,
    output reg [15:0] y0_real, y0_imag,
    output reg [15:0] y1_real, y1_imag,
    output reg [15:0] y2_real, y2_imag,
    output reg [15:0] y3_real, y3_imag,
    output reg done
);
    reg [2:0] state;
    
    parameter IDLE = 3'b000, COMPUTE = 3'b001, OUTPUT = 3'b010;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case(state)
                IDLE: begin
                    if (!done) state <= COMPUTE;
                end
                COMPUTE: begin
                    // FFT computation (basic butterfly operations)
                    y0_real <= x0_real + x1_real;
                    y0_imag <= x0_imag + x1_imag;
                    y1_real <= x0_real - x1_real;
                    y1_imag <= x0_imag - x1_imag;
                    y2_real <= x2_real + x3_real;
                    y2_imag <= x2_imag + x3_imag;
                    y3_real <= x2_real - x3_real;
                    y3_imag <= x2_imag - x3_imag;
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule