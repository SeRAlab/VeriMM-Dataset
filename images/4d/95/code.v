module top_module(
    input [7:0] a,
    input [7:0] b,
    input ctrl,
    input rst,
    input clk,           // Added clock input
    output reg [7:0] out
);always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
        out <= 8'b0;
    end else begin
        if (ctrl == 0) begin
            out <= a + b;
        end else begin
            out <= a - b;
        end
    end
end

endmodule