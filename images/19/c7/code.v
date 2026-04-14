module ecc_point_addition (
    input clk,
    input reset,
    input start,
    input [15:0] x1, y1, x2, y2,
    output reg [15:0] x3, y3,
    output reg done
);
    reg [15:0] lambda;
    reg [3:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x3 <= 0;
            y3 <= 0;
            lambda <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (start) begin
                        // Calculate lambda = (y2 - y1) / (x2 - x1)
                        if (x2 != x1) begin
                            lambda <= (y2 - y1) / (x2 - x1);
                            state <= 1;
                        end else begin
                            // Handle the case where points are equal or vertical line
                            x3 <= x1;
                            y3 <= y1;
                            done <= 1;
                        end
                    end
                end
                1: begin
                    // Calculate x3 = lambda^2 - x1 - x2
                    x3 <= (lambda * lambda) - x1 - x2;
                    state <= 2;
                end
                2: begin
                    // Calculate y3 = lambda * (x1 - x3) - y1
                    y3 <= (lambda * (x1 - x3)) - y1;
                    done <= 1;  // Operation done
                    state <= 0; // Reset state
                end
            endcase
        end
    end
endmodule