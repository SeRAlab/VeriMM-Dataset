module up_down_counter(
    input clk,
    input reset,
    input enable,
    input direction,
    output reg [3:0] count
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 4'b0000; // Reset count to 0
    end else if (enable) begin
        if (direction) begin
            count <= count - 1; // Count down
        end else begin
            count <= count + 1; // Count up
        end
    end

endmodule