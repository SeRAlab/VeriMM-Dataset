module top_module(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg overflow
);always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        overflow <= 0;
    end else if (count == 15) begin
        count <= 0;
        overflow <= 1;
    end else begin
        count <= count + 1;
        overflow <= 0;
    end
end

endmodule