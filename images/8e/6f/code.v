module top_module(
    input reset,
    input clk,
    output reg [3:0] count
);always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (count == 15) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

endmodule