module gradient_descent(
    input clk,
    input reset,
    input [31:0] initial_x,
    input [31:0] learning_rate,
    input [3:0] iterations,
    output reg [31:0] x,
    output reg done
);
    reg [3:0] count;
    reg [31:0] derivative;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= initial_x;
            count <= 0;
            done <= 0;
        end else if (count < iterations) begin
            derivative <= 2 * (x - 5);
            x <= x - (learning_rate * derivative);
            count <= count + 1;
        end else begin
            done <= 1;
        end
    end
endmodule