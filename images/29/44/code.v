module pipeline_adder (
    input wire clk,
    input wire rst,
    input wire [3:0] a,
    input wire [3:0] b,
    output reg [4:0] sum
);
    reg [3:0] stage1_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out <= 4'b0000;
            sum <= 5'b00000;
        end else begin
            stage1_out <= a + b; // Stage 1: Add a and b
            sum <= stage1_out;    // Stage 2: Output the result
        end
    end
endmodule