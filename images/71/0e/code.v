module top_module(
    input clk,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);reg [3:0] pipeline_reg1, pipeline_reg2, pipeline_reg3;

always @(posedge clk) begin
    pipeline_reg1 <= data_in;
    pipeline_reg2 <= pipeline_reg1;
    pipeline_reg3 <= pipeline_reg2;
    data_out <= pipeline_reg3;
end

always @(posedge clk) begin
    if (load) begin
        pipeline_reg1 <= data_in;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
        data_out <= pipeline_reg3;
    end
end

endmodule