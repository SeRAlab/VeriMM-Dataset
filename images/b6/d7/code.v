module top_module(
    input clk,
    input SER_IN,
    input SH_EN,
    output [3:0] PAR_OUT
);reg [3:0] pipeline_reg1, pipeline_reg2, pipeline_reg3, pipeline_reg4;

always @(posedge clk) begin
    if (SH_EN) begin
        pipeline_reg1 <= SER_IN;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
        pipeline_reg4 <= pipeline_reg3;
    end else begin
        pipeline_reg1 <= pipeline_reg1;
        pipeline_reg2 <= pipeline_reg2;
        pipeline_reg3 <= pipeline_reg3;
        pipeline_reg4 <= pipeline_reg4;
    end
end

assign PAR_OUT = pipeline_reg4;

endmodule