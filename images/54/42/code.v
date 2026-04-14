module top_module(
    input [31:0] in,
    input clk,                // Added clk input
    input rst,                // Added reset input for better design practice
    output [31:0] out
);reg [31:0] pipeline_reg [0:3];

assign out = pipeline_reg[3];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipeline_reg[0] <= 32'b0;
        pipeline_reg[1] <= 32'b0;
        pipeline_reg[2] <= 32'b0;
        pipeline_reg[3] <= 32'b0;
    end else begin
        pipeline_reg[0] <= in;
        pipeline_reg[1] <= {pipeline_reg[0][7:0], pipeline_reg[0][15:8], pipeline_reg[0][23:16], pipeline_reg[0][31:24]};
        pipeline_reg[2] <= {pipeline_reg[1][15:0], pipeline_reg[1][31:16]};
        pipeline_reg[3] <= {pipeline_reg[2][23:0], pipeline_reg[2][31:24]};
    end
end

endmodule