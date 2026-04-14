module up_down_counter (
    input clk,
    input rst,
    input en,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b0000; // Reset counter to 0
    end else if (en) begin
        if (up_down) begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Count up with wrap around
        end else begin
            count <= (count == 4'b0000) ? 4'b1111 : count - 1; // Count down with wrap around
        end
    end
end

endmodule