module pipeline_processor (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_out;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1_out <= data_in + 1; // Stage 1 operation: increment input
            data_out <= stage1_out * 2; // Stage 2 operation: double the output of stage 1
        end
    end
endmodule