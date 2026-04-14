module mpc_controller (  
    input clk,  
    input reset,  
    input control,  // 0: decrement, 1: increment  
    output reg [3:0] state  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= 4'd0;  
        else begin  
            if (control)  
                state <= state + 1;  // Increment  
            else  
                state <= state - 1;  // Decrement  
        end  
    end  
endmodule