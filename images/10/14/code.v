module pipeline_processor (
    input clk,
    input [3:0] in_data,
    output reg [3:0] out_data
);

    reg [3:0] stage1_reg;

    // Stage 1: Increment input by 1
    always @(posedge clk) begin
        stage1_reg <= in_data + 1;
    end

    // Stage 2: Multiply result of stage 1 by 2
    always @(posedge clk) begin
        out_data <= stage1_reg * 2;
    end

endmodule