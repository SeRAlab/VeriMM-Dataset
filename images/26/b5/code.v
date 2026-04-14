module up_down_counter(
    input clk,
    input reset,
    input up,
    input down,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset the counter to 0
        end else if (up && !down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Increment with wrap around
        end else if (down && !up) begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Decrement with wrap around
        end
    end
endmodule