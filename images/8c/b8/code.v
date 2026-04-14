module binary_up_down_counter
(
    input clk,
    input reset,
    input dir,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b00000; // Clear counter to 0
        end else begin
            if (dir) begin
                count <= count + 1; // Count up
            end else begin
                count <= count - 1; // Count down
            end
        end
    end

endmodule