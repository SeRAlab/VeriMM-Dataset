module top_module(
    input clk,
    input rst,
    input ena,
    input [15:0] data_in,
    output reg [15:0] data_out
);reg [15:0] pipeline_reg [1:2];

always @(posedge clk) begin
    if (rst) begin
        pipeline_reg[1] <= 16'b0;
        pipeline_reg[2] <= 16'b0;
    end
    else if (ena) begin
        pipeline_reg[1] <= data_in;
        pipeline_reg[2] <= pipeline_reg[1];
    end
    else begin
        pipeline_reg[1] <= pipeline_reg[2];
        pipeline_reg[2] <= pipeline_reg[1] << 1;
    end
end

assign data_out = pipeline_reg[1];

endmodule