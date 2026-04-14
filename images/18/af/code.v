module sata_controller(  
    input clk,  
    input reset,  
    input start,  
    input error,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              ACTIVE = 2'b01,  
              ERROR = 2'b10;  
              
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= ACTIVE;  
                ACTIVE: if (error) state <= ERROR;  
                ERROR: if (reset) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule