module binary_counter_with_enable(
    input clk,
    input enable,
    input clear,
    output reg [3:0] count);always @(posedge clk or posedge clear) begin
    if (clear) begin
        count <= 4'b0000;
    end
    else if (enable) begin
        count <= count + 1;
    end
end
endmodule