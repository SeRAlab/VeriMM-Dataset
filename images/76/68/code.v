module top_module(
    input clk,
    input reset,
    output reg [15:0] count
);always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

endmodule