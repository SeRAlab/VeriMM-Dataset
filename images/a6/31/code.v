module up_counter_by_2 (
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] count
);always @(posedge clk) begin
    if (!reset_n) begin
        count <= 8'b00000000;
    end else if (enable) begin
        count <= count + 2;
    end
end

endmodule