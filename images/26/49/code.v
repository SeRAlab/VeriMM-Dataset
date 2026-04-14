module pipeline_register (
    input clk,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1;

    always @(posedge clk) begin
        stage1 <= data_in; // Stage 1: Register input
        data_out <= stage1; // Stage 2: Pass to output
    end
endmodule