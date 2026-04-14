module pipeline_processor(
    input clk,
    input reset,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 5'b0;
            data_out <= 5'b0;
        end else begin
            stage1_reg <= data_in;
            data_out <= stage1_reg + 1;
        end
    end
endmodule