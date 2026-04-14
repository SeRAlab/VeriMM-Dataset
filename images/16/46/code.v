module slam_system(  
    input clk,  
    input reset,  
    input trigger,  
    output reg [1:0] state  
);  

    parameter IDLE = 2'b00,  
              MAPPING = 2'b01,  
              LOCALIZING = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else if (trigger) begin  
            case (state)  
                IDLE: state <= MAPPING;  
                MAPPING: state <= LOCALIZING;  
                LOCALIZING: state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule