module up_down_counter_with_enable (
    input clk,
    input reset,
    input enable,
    input up,
    input down,
    output reg [7:0] count
);always @(posedge clk) begin
    if (reset) begin
        count <= 8'b00000000;
    end else if (enable) begin
        if (up) begin
            count <= count + 1;
        end else if (down) begin
            count <= count - 1;
        end
    end
end

endmodule