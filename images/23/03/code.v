module pipeline_system (
    input clk,
    input rst,
    input valid_in,
    input [7:0] A,
    input [7:0] B,
    output reg valid_out,
    output reg [15:0] Y
);
    reg [7:0] sum_stage;
    reg [15:0] product_stage;
    parameter C = 8'd5;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_stage <= 8'b0;
            product_stage <= 16'b0;
            Y <= 16'b0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                sum_stage <= A + B; // Stage 1: Calculate sum
            end
            product_stage <= sum_stage * C; // Stage 2: Calculate product
            Y <= product_stage;
            valid_out <= valid_in; // Output valid signal
        end
    end
endmodule