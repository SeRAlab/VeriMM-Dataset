module up_down_counter (
    input clk,
    input rst,
    input en,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000; // Reset the counter to 0
        end else if (en) begin
            if (up_down)
                count <= count + 1; // Increment
            else
                count <= count - 1; // Decrement
        end
    end
endmodule