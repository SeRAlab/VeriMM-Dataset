module factorial(
    input clk,
    input reset,
    input start,
    input [3:0] n,
    output reg [31:0] result,
    output reg done
);
    reg [3:0] current;
    reg [31:0] product;
    reg calculating;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 32'd1;
            done <= 1'b0;
            current <= 4'd0;
            product <= 32'd1;
            calculating <= 1'b0;
        end else if (start && !calculating) begin
            current <= n;
            product <= 32'd1;
            calculating <= 1'b1;
            done <= 1'b0;
        end else if (calculating) begin
            if (current > 4'd1) begin
                product <= product * current;
                current <= current - 1;
            end else begin
                result <= product;
                calculating <= 1'b0;
                done <= 1'b1;
            end
        end
    end
endmodule