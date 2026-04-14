module pipelined_processor(
    input [7:0] data_in,
    input clk,
    input enable,
    output reg [7:0] data_out
);
    reg [7:0] stage1_reg;
    reg [7:0] stage2_reg;

    always @(posedge clk) begin
        if (enable) begin
            stage1_reg <= data_in + 1;
            stage2_reg <= stage1_reg;
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            data_out <= stage2_reg;
        end
    end
endmodule