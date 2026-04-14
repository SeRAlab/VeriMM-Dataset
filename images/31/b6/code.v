module slam_fsm (  
    input clk,  
    input reset,  
    input start,  
    input navigate,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              MAP = 2'b01,  
              NAVIGATE = 2'b10;  

    // State transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= MAP;  
                end  
                MAP: begin  
                    if (navigate)  
                        state <= NAVIGATE;  
                end  
                NAVIGATE: begin  
                    if (reset)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule