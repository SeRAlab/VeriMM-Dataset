module up_down_counter (
    input clk,
    input reset,
    input enable,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (enable) begin
        if (up_down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Count up with wrap around
        end else begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Count down with wrap around
        end
    end
end

endmodule