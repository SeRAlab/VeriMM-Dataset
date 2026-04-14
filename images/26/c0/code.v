module fan_speed_controller(  
    input clk,  
    input rst,  
    input [1:0] speed_input,  
    output reg [1:0] current_speed  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            current_speed <= 2'b00; // Off  
        else  
            current_speed <= speed_input;  
    end  
endmodule