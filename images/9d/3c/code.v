module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input clk,             // Added clk input
    output reg [1:0] result
);reg [3:0] in0_reg;
reg [3:0] in1_reg;
reg [1:0] result_reg;

always @(posedge clk) begin
    in0_reg <= in0;
    in1_reg <= in1;
end

always @(posedge clk) begin
    if (in0_reg > in1_reg) begin
        result_reg <= 2'b01;
    end else if (in0_reg < in1_reg) begin
        result_reg <= 2'b10;
    end else begin
        result_reg <= 2'b00;
    end
end

assign result = result_reg;

endmodule