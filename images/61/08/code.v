module up_down_counter
(
    input clk,
    input reset,
    input up,
    input down,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000; // Reset counter to 0000
        end else if (up) begin
            count <= count + 1; // Increment counter
        end else if (down) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule