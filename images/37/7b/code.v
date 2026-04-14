module pipeline_2stage (
    input clk,
    input [4:0] data_in,
    output reg [5:0] data_out
);
    reg [4:0] stage1_out;

    always @(posedge clk) begin
        // Stage 1: Increment by 1
        stage1_out <= data_in + 1;
    end

    always @(posedge clk) begin
        // Stage 2: Multiply by 2
        data_out <= stage1_out * 2;
    end
endmodule