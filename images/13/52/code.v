module fft_4point (
    input clk,
    input [15:0] x0, x1, x2, x3, // 4 complex inputs (real and imaginary)
    input start,
    output reg [15:0] y0, y1, y2, y3, // 4 complex outputs
    output reg done
);

reg [3:0] state;
parameter IDLE = 0, COMPUTE = 1, OUTPUT = 2;

always @(posedge clk) begin
    case(state)
        IDLE: begin
            if (start) begin
                state <= COMPUTE;
                done <= 0;
            end
        end
        
        COMPUTE: begin
            // FFT calculation for 4 points
            y0 <= x0 + x1 + x2 + x3; // example computation
            y1 <= x0 - x1 + x2 - x3; // example computation
            y2 <= x0 + x1 - x2 - x3; // example computation
            y3 <= x0 - x1 - x2 + x3; // example computation
            state <= OUTPUT;
        end
        
        OUTPUT: begin
            done <= 1;
            state <= IDLE;
        end
    endcase
end

endmodule