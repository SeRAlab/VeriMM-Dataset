module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] max,
    output reg [31:0] min
);reg [31:0] current_max;
reg [31:0] current_min;

always @(posedge clk) begin
    if (reset) begin
        current_max <= 32'h80000000;
        current_min <= 32'h7FFFFFFF;
    end else begin
        if (in > current_max) begin
            current_max <= in;
        end
        if (in < current_min) begin
            current_min <= in;
        end
    end
end

assign max = current_max;
assign min = current_min;

endmodule