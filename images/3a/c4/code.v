module deadbeat_controller(  
    input clk,  
    input [2:0] current_state,  
    input [2:0] desired_state,  
    output reg [2:0] control_output  
);  

always @(posedge clk) begin  
    control_output <= desired_state;  
end  
endmodule