module rrt_node_generator(  
    input clk,  
    input [7:0] random_input_x,  
    input [7:0] random_input_y,  
    input [7:0] max_step_size,  
    output reg [7:0] new_node_x,  
    output reg [7:0] new_node_y  
);  

    always @(posedge clk) begin  
        new_node_x <= random_input_x + (random_input_x % max_step_size);  
        new_node_y <= random_input_y + (random_input_y % max_step_size);  
    end  
endmodule