module top_module(
    input clk,
    input [2:0] in,
    output reg [7:0] out
);reg [7:0] pipeline_reg;

always @(posedge clk) begin
    pipeline_reg <= {pipeline_reg[6:0], 1'b0};
end

always @(posedge clk) begin
    pipeline_reg <= 8'b00000000; // Clear the register before setting the new value
    case (in)
        3'b000: pipeline_reg[7] <= 1'b1;
        3'b001: pipeline_reg[6] <= 1'b1;
        3'b010: pipeline_reg[5] <= 1'b1;
        3'b011: pipeline_reg[4] <= 1'b1;
        3'b100: pipeline_reg[3] <= 1'b1;
        3'b101: pipeline_reg[2] <= 1'b1;
        3'b110: pipeline_reg[1] <= 1'b1;
        3'b111: pipeline_reg[0] <= 1'b1;
    endcase
end

assign out = pipeline_reg;

endmodule