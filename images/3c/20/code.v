module mpc_control(clk, rst, state, setpoint, control_output);  
    input clk, rst;  
    input [7:0] state;  
    input [7:0] setpoint;  
    output reg [7:0] control_output;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_output <= 8'b0;  
        end else begin  
            // Simple control logic: control_output = setpoint - state  
            control_output <= setpoint - state;  
        end  
    end  
endmodule