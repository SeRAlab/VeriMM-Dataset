module top_module(
    input clk,
    input reset,
    input [7:0] in,
    output reg [3:0] out
);reg [7:0] constant = 8'b11110000;
reg [3:0] counter = 4'b0000;

always @(posedge clk) begin
    if (reset) begin
        out <= 4'b0000;
        counter <= 4'b0000;
    end else begin
        out <= (in * constant) + counter;
        counter <= counter + 1;
    end
end

endmodule