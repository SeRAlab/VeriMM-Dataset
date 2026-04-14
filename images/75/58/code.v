module top_module(
    input rst,
    input sel,
    input clk,                 // Added clk input
    input [31:0] in1,
    input [31:0] in2,
    output reg [31:0] out
);always @(posedge clk) begin
    if (rst) begin
        out <= 0;
    end else begin
        if (sel) begin
            out <= in1;
        end else begin
            out <= in2;
        end
    end
end

endmodule