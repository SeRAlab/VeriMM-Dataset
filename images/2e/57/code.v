module pipeline_processor (
    input clk,
    input rst,
    input [3:0] in_data,
    output reg [3:0] out_data
);
    reg [3:0] stage1_data;

    // Stage 1: Addition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_data <= 4'b0000;
        end else begin
            stage1_data <= in_data + 4'b0011; // Adding constant 3
        end
    end

    // Stage 2: Multiplication
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data <= 4'b0000;
        end else begin
            out_data <= stage1_data * 2; // Multiplying by 2
        end
    end
endmodule