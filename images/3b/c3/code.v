module RRT (
    input clk,
    input rst,
    input [7:0] target_x,
    input [7:0] target_y,
    input [7:0] step_size,
    output reg [7:0] tree_x,
    output reg [7:0] tree_y,
    output reg valid
);
    reg [7:0] current_x;
    reg [7:0] current_y;

    initial begin
        current_x = 8'b0;
        current_y = 8'b0;
        valid = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_x <= 0;
            current_y <= 0;
            valid <= 0;
        end else begin
            if (current_x < target_x) begin
                current_x <= current_x + step_size;
            end else if (current_x > target_x) begin
                current_x <= current_x - step_size;
            end

            if (current_y < target_y) begin
                current_y <= current_y + step_size;
            end else if (current_y > target_y) begin
                current_y <= current_y - step_size;
            end

            if (current_x == target_x && current_y == target_y) begin
                valid <= 1;
            end

            tree_x <= current_x;
            tree_y <= current_y;
        end
    end
endmodule