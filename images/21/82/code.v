module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up,
    input wire down,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000; // Reset the counter to 0
    end else if (up && !down) begin
        count <= count + 1; // Count up
    end else if (down && !up) begin
        count <= count - 1; // Count down
    end
    // if both up and down are high, do nothing (hold current value)
end

endmodule