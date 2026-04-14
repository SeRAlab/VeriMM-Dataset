module pipeline_processor (
    input clk,
    input rst,
    input [4:0] in_data,
    output reg [4:0] out_data
);
    reg [4:0] stage1_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out <= 5'b0;
            out_data <= 5'b0;
        end else begin
            stage1_out <= in_data + 5'd3; // Add 3 in the first stage
            out_data <= stage1_out - 5'd1; // Subtract 1 in the second stage
        end
    end
endmodule