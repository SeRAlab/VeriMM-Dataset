module state_space_controller(  
    input clk,  
    input reset,  
    input ctrl,  
    output reg [0:0] state  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= 1'b0; // Initialize to state S0  
        else begin  
            if (ctrl)  
                state <= 1'b1; // Transition to state S1  
            else  
                state <= 1'b0; // Transition to state S0  
        end  
    end  
endmodule