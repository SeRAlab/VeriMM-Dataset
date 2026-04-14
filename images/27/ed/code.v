module mpc_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] current_state,  
    input wire [3:0] desired_state,  
    output reg [3:0] control_signal  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        control_signal <= 4'b0000;  
    else  
        control_signal <= desired_state - current_state;  
end  
endmodule