module top_module(
    input clk,
    input rst,
    input [31:0] in,
    input in_valid,
    output reg [31:0] out,
    output reg out_valid
);reg [31:0] sum;
reg [31:0] count;

always @(posedge clk) begin
    if (rst) begin
        sum <= 0;
        count <= 0;
        out_valid <= 0;
    end else if (in_valid) begin
        sum <= sum + in;
        count <= count + 1;
    end else if (count > 0) begin
        out <= sum;
        out_valid <= 1;
        sum <= 0;
        count <= 0;
    end else begin
        out_valid <= 0;
    end
end

endmodule