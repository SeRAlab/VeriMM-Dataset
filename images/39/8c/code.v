module SLAM_State_Machine(  
    input clk,  
    input reset,  
    input start,  
    input map,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              MOVING = 2'b01,  
              MAPPING = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= MOVING;  
                MOVING: if (map) state <= MAPPING;  
                MAPPING: state <= IDLE;  
            endcase  
        end  
    end  
endmodule