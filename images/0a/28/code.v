module mpc_controller (  
    input clk,  
    input reset,  
    input [3:0] current_state,  
    input [3:0] control_input,  
    output reg [3:0] next_state,  
    output reg control_signal  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_state <= 4'b0000;  
            control_signal <= 1'b0;  
        end else begin  
            // Example state transition logic  
            next_state <= current_state + control_input;  
            
            // Control signal logic based on desired state (e.g., 4'b1111)  
            if (next_state == 4'b1111) begin  
                control_signal <= 1'b1;  
            end else begin  
                control_signal <= 1'b0;  
            end  
        end  
    end  
endmodule