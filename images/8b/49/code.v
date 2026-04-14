module up_down_counter
(
    input clk,
    input reset,
    input enable,
    input dir,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b00000000; // Clear count to 0
        end else if (enable) begin
            if (dir) begin
                count <= count + 1; // Count up
            end else begin
                count <= count - 1; // Count down
            end
        end
    end

endmodule