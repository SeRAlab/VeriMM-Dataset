module top_module(
    input clk,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);reg [7:0] pipeline_reg [0:1];

always @(posedge clk) begin
    if (load) begin
        pipeline_reg[0] <= data_in;
    end else begin
        pipeline_reg[0] <= {pipeline_reg[1][6:0], 1'b0};
    end
    pipeline_reg[1] <= pipeline_reg[0];
end

assign data_out = pipeline_reg[1];

endmodule