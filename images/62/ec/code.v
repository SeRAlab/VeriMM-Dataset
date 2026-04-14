module counter2 (
    input clk,
    input reset,
    output reg [1:0] count);always @(posedge clk) begin
    if (reset)
        count <= 2'b0;
    else
        count <= count + 1;
end
endmodule