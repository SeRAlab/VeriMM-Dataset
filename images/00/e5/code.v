module deadbeat_controller (  
    input clk,  
    input rst,  
    input [3:0] current_state,  
    input [3:0] desired_state,  
    output reg [3:0] control_output  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            control_output <= 4'b0000;  
        else  
            control_output <= desired_state - current_state;  
    end  
endmodule