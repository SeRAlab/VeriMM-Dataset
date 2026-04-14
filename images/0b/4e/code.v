module SLAM_SM (  
    input clk,  
    input reset,  
    input start,  
    output reg [1:0] state  
);  

    // State Encoding  
    parameter IDLE = 2'b00,  
              MAP = 2'b01,  
              LOCATE = 2'b10;  

    // State Transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= MAP;  
                MAP: state <= LOCATE;  
                LOCATE: state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule