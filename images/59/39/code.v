module top_module(
    input wire clk_in,
    output reg clk_out
);localparam CYCLE_COUNT = 1024;
localparam CLK_PERIOD = 10;
localparam CLK_DUTY_CYCLE = 0.25;
localparam CLK_SUB_PERIOD = CLK_PERIOD / 4;

reg [1:0] sub_clk_count;
reg [9:0] cycle_count;

always @(posedge clk_in) begin
    sub_clk_count <= sub_clk_count + 1;
    if (sub_clk_count == 2'b11) begin
        sub_clk_count <= 0;
        cycle_count <= cycle_count + 1;
    end
end

always @(posedge clk_in) begin
    if (cycle_count >= CYCLE_COUNT) begin
        clk_out <= 1'b0;
    end else begin
        if (sub_clk_count == 2'b00) begin
            clk_out <= 1'b1;
        end else if (sub_clk_count == 2'b01) begin
            clk_out <= 1'b0;
        end else if (sub_clk_count == 2'b10) begin
            clk_out <= 1'b0;
        end else if (sub_clk_count == 2'b11) begin
            clk_out <= 1'b0;
        end
    end
end

endmodule