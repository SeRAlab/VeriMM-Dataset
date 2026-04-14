module cordic_vectoring (
    input clk,
    input rst,
    input signed [15:0] x_input,
    input signed [15:0] y_input,
    output reg signed [15:0] angle_output
);
    reg signed [15:0] x;
    reg signed [15:0] y;
    integer i;
    parameter NUM_ITERATIONS = 16;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            angle_output <= 0;
            x <= 0;
            y <= 0;
            i <= 0;
        end else begin
            if (i < NUM_ITERATIONS) begin
                // CORDIC iteration
                if (y < 0) begin
                    x <= x + (y >>> i);
                    y <= y + (x >>> i);
                    angle_output <= angle_output - (16'h1 >>> i);
                end else begin
                    x <= x - (y >>> i);
                    y <= y - (x >>> i);
                    angle_output <= angle_output + (16'h1 >>> i);
                end
                i <= i + 1;
            end
        end
    end
endmodule