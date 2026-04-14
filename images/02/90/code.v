module deadbeat_controller(  
    input clk,  
    input [7:0] setpoint,  
    input [7:0] current_output,  
    output reg [7:0] control_signal  
);  
    always @(posedge clk) begin  
        control_signal <= setpoint - current_output;  
    end  
endmodule