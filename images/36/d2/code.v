module pcie_controller (  
    input clk,  
    input reset,  
    input start,  
    input stop,  
    output reg state  
);  
    // State encoding  
    parameter IDLE = 1'b0;  
    parameter ACTIVE = 1'b1;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= ACTIVE;  
                end  
                ACTIVE: begin  
                    if (stop)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule