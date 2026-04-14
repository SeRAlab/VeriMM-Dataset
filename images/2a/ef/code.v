module sata_controller (  
    input clk,  
    input reset,  
    input start,  
    input sleep,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, ACTIVE = 2'b01, SLEEP = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= ACTIVE;  
                ACTIVE: if (sleep) state <= SLEEP;  
                SLEEP: if (reset) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule