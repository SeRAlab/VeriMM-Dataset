module RRT (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] start_x,  
    input wire [7:0] start_y,  
    input wire [7:0] goal_x,  
    input wire [7:0] goal_y,  
    output reg [7:0] path_x,  
    output reg [7:0] path_y,  
    output reg goal_reached  
);  
    // Internal state variables  
    reg [7:0] current_x, current_y;  
    reg [7:0] next_x, next_y;  
    reg exploring;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_x <= start_x;  
            current_y <= start_y;  
            goal_reached <= 0;  
            exploring <= 1;  
        end else if (exploring) begin  
            // Simple exploration logic (random walk simulation)  
            // Update next_x and next_y with some logic  
            // For simplicity, let's assume we move towards the goal in steps  
            if (current_x < goal_x)  
                next_x <= current_x + 1;  
            else if (current_x > goal_x)  
                next_x <= current_x - 1;  
            else  
                next_x <= current_x;  

            if (current_y < goal_y)  
                next_y <= current_y + 1;  
            else if (current_y > goal_y)  
                next_y <= current_y - 1;  
            else  
                next_y <= current_y;  

            // Update the current position  
            current_x <= next_x;  
            current_y <= next_y;  

            // Check if goal is reached  
            if (current_x == goal_x && current_y == goal_y) begin  
                goal_reached <= 1;  
                path_x <= current_x;  
                path_y <= current_y;  
                exploring <= 0;  
            end else begin  
                path_x <= current_x;  
                path_y <= current_y;  
            end  
        end  
    end  
endmodule