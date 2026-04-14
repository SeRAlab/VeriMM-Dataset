module binary_counter_with_overflow(
    input clk,
    input enable,
    output reg [1:0] count,
    output reg overflow);always @(posedge clk) begin
    if (enable) begin
        if (count == 2'b11) begin
            count <= 2'b00;
            overflow <= 1'b1;
        end
        else begin
            count <= count + 1;
            overflow <= 1'b0;
        end
    end
end
endmodule