module RRT_Node_Manager(
    input clk,
    input rst,
    input [7:0] x_in,
    input [7:0] y_in,
    input add_node,
    input random_walk,
    output reg [7:0] last_x,
    output reg [7:0] last_y
);

    reg [7:0] current_x;
    reg [7:0] current_y;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_x <= 8'b0;
            current_y <= 8'b0;
            last_x <= 8'b0;
            last_y <= 8'b0;
        end else begin
            if (add_node) begin
                current_x <= x_in;
                current_y <= y_in;
            end
            
            if (random_walk) begin
                last_x <= current_x + $random % 3 - 1; // Random walk in range -1 to 1
                last_y <= current_y + $random % 3 - 1; // Random walk in range -1 to 1
            end
        end
    end
endmodule