module wifi_controller(  
    input clk,  
    input reset,  
    input start,  
    input success,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;  
  
    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= CONNECTING;  
                CONNECTING: if (success) state <= CONNECTED;  
                CONNECTED: if (reset) state <= IDLE;  
                DISCONNECTED: if (reset) state <= IDLE;  
            endcase  
        end  
    end  
endmodule