module fft_4point(
    input clk,
    input reset,
    input [7:0] x0, x1, x2, x3,
    output reg [7:0] y0, y1, y2, y3
);
    reg [7:0] a0, a1, a2, a3;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y0 <= 8'b0;
            y1 <= 8'b0;
            y2 <= 8'b0;
            y3 <= 8'b0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    a0 <= x0 + x2;
                    a1 <= x1 + x3;
                    a2 <= x0 - x2;
                    a3 <= (x1 - x3) * 8'h28; // W factor for FFT
                    y0 <= a0 + a1;
                    y1 <= a2 + a3;
                    y2 <= a0 - a1;
                    y3 <= a2 - a3;
                    state <= state + 1;
                end
                1: begin
                    // Output results on the next clock cycle
                    state <= state + 1;
                end
                default: begin
                    state <= 0;
                end
            endcase
        end
    end
endmodule