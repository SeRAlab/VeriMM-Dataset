module up_down_counter (
    input wire clk,
    input wire reset_n,
    input wire up,
    input wire down,
    output reg [3:0] count
);
    
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            count <= 4'b0000; // Reset to 0
        end else if (up && !down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Count Up with wrap around
        end else if (down && !up) begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Count Down with wrap around
        end
    end
endmodule