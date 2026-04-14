module bluetooth_fsm(  
    input clk,  
    input reset,  
    input start,  
    input connected,  
    input disconnect,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10,  
              DISCONNECTED = 2'b11;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: if (start) state <= CONNECTING;  
                CONNECTING: if (connected) state <= CONNECTED;  
                CONNECTED: if (disconnect) state <= DISCONNECTED;  
                DISCONNECTED: if (reset) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule