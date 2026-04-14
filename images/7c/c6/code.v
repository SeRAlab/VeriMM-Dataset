module up_down_counter
(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'b0000000000000000; // Clear counter to 0
        end else if (up_down) begin
            count <= count + 1; // Increment counter
        end else begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule