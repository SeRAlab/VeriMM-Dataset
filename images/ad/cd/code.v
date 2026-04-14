module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] pipeline_reg1, pipeline_reg2, pipeline_reg3;

always @(posedge clk) begin
    if (load) begin
        pipeline_reg1 <= data;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
    end else begin
        pipeline_reg1 <= pipeline_reg3;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
    end
end

always @* begin
    case (ena)
        2'b00: q = pipeline_reg3;
        2'b01: q = {pipeline_reg3[99], pipeline_reg3[98:0]};
        2'b10: q = {pipeline_reg3[98:0], pipeline_reg3[99]};
        2'b11: q = pipeline_reg3;
        default: q = 100'b0; // Default case for safety
    endcase
end

endmodule