module up_down_counter (
    input wire clk,
    input wire reset,
    input wire up,
    input wire down,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset counter to 0
        end else if (up && !down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Increment with wrap-around
        end else if (down && !up) begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Decrement with wrap-around
        end
    end
endmodule