module top_module(
    input clk,
    input sel2,
    input sel1,
    input sel0,
    output reg [63:0] out
);reg [63:0] stage1_out;
reg [63:0] stage2_out;

always @(*) begin
    // Initialize stage1_out to zero
    stage1_out = 64'b0;

    if(sel2 == 0 && sel1 == 0 && sel0 == 0) begin
        stage1_out[0] = 1'b1;
    end
    else if(sel2 == 1 && sel1 == 0 && sel0 == 0) begin
        stage1_out[8] = 1'b1;
    end
    else if(sel2 == 0 && sel1 == 1 && sel0 == 1) begin
        stage1_out[56] = 1'b1;
    end
    else if(sel2 == 1 && sel1 == 1 && sel0 == 0) begin
        stage1_out[60] = 1'b1;
    end
    else if(sel2 == 0 && sel1 == 1 && sel0 == 0) begin
        stage1_out[48] = 1'b1;
    end
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

assign out = stage2_out;

endmodule