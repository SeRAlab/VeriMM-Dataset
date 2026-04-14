module pipeline_adder (
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] sum
);
    reg [7:0] stage [0:6]; // 7 stages of pipeline

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 8'b0;
            stage[0] <= 8'b0;
            stage[1] <= 8'b0;
            stage[2] <= 8'b0;
            stage[3] <= 8'b0;
            stage[4] <= 8'b0;
            stage[5] <= 8'b0;
            stage[6] <= 8'b0;
        end else begin
            stage[0] <= A + B; // Stage 1: Compute sum
            stage[1] <= stage[0]; // Stage 2
            stage[2] <= stage[1]; // Stage 3
            stage[3] <= stage[2]; // Stage 4
            stage[4] <= stage[3]; // Stage 5
            stage[5] <= stage[4]; // Stage 6
            stage[6] <= stage[5]; // Stage 7
            sum <= stage[6]; // Final output after 7 cycles
        end
    end
endmodule