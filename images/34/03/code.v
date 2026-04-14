module bluetooth_controller (  
    input clk,  
    input reset,  
    input start,  
    input success,  
    output reg [1:0] state  
);  
    // State declaration  
    parameter IDLE = 2'b00;  
    parameter CONNECTING = 2'b01;  
    parameter CONNECTED = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    if (success)  
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (!success)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule