module top_module(
    input clk,
    input rst,
    output reg [7:0] cnt
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        cnt <= 8'b0;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule