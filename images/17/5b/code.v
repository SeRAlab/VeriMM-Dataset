module wifi_module (  
    input clk,  
    input reset,  
    input start_connect,  
    input success,  
    input disconnect,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10,  
              DISCONNECTING = 2'b11;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_connect)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    if (success)  
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (disconnect)  
                        state <= DISCONNECTING;  
                end  
                DISCONNECTING: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule