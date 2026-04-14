module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] stage1_reg, stage2_reg, stage3_reg;

always @(posedge clk) begin
    if (reset) begin
        stage1_reg <= 4'b0;
        stage2_reg <= 4'b0;
        stage3_reg <= 4'b0;
    end
    else if (load) begin
        stage1_reg <= data_in;
        stage2_reg <= stage1_reg;
        stage3_reg <= stage2_reg;
    end
    else begin
        stage1_reg <= stage1_reg + 4'b1;
        stage2_reg <= stage1_reg;
        stage3_reg <= stage2_reg;
    end
end

assign data_out = stage3_reg;

endmodule