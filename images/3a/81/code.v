module fft_4point(
    input clk,
    input rst,
    input start,
    input [15:0] x0, // Complex input 0 (real, imag)
    input [15:0] x1, // Complex input 1 (real, imag)
    input [15:0] x2, // Complex input 2 (real, imag)
    input [15:0] x3, // Complex input 3 (real, imag)
    output reg [15:0] y0, // Complex output 0 (real, imag)
    output reg [15:0] y1, // Complex output 1 (real, imag)
    output reg [15:0] y2, // Complex output 2 (real, imag)
    output reg [15:0] y3, // Complex output 3 (real, imag)
    output reg done // Output valid signal
);
    reg [1:0] state;
    reg [15:0] w0, w1, w2, w3; // Twiddle factors
    reg [15:0] temp0, temp1, temp2, temp3; // Temporary storage for FFT calculations

    localparam IDLE = 2'b00;
    localparam COMPUTE = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Initialize twiddle factors
                        w0 <= 16'h0001; // e^(j*0)
                        w1 <= 16'h0000; // e^(j*pi/2)
                        w2 <= 16'hFFFF; // e^(j*pi)
                        w3 <= 16'h0000; // e^(j*3*pi/2)
                        state <= COMPUTE;
                        done <= 0;
                    end
                end
                COMPUTE: begin
                    // Perform FFT computation here
                    // Using a simple radix-2 decimation-in-time FFT
                    temp0 <= x0 + x2; // FFT computation for output 0
                    temp1 <= x1 + x3; // FFT computation for output 1
                    temp2 <= x0 - x2; // FFT computation for output 2
                    temp3 <= x1 - x3; // FFT computation for output 3

                    y0 <= temp0; // Output 0
                    y1 <= temp1; // Output 1
                    y2 <= temp2; // Output 2
                    y3 <= temp3; // Output 3

                    state <= DONE;
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule