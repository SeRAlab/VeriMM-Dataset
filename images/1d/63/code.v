module wifi_state_machine(  
    input wire clk,  
    input wire reset,  
    input wire start_connect,  
    input wire connect_success,  
    input wire disconnect,  
    output reg [1:0] state  
);  

    // State encoding  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10,  
              DISCONNECTED = 2'b11;  

    // State transition logic  
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
                    if (connect_success)  
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (disconnect)  
                        state <= DISCONNECTED;  
                end  
                DISCONNECTED: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule