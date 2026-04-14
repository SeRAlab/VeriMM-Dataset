module wifi_connection_fsm (  
    input clk,  
    input reset,  
    input start_connection,  
    input connection_success,  
    input connection_fail,  
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED  
);  

    // State encoding  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10,  
              DISCONNECTED = 2'b11;  

    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start_connection)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    if (connection_success)  
                        state <= CONNECTED;  
                    else if (connection_fail)  
                        state <= DISCONNECTED;  
                end  
                CONNECTED: begin  
                    if (connection_fail)  
                        state <= DISCONNECTED;  
                end  
                DISCONNECTED: begin  
                    if (start_connection)  
                        state <= CONNECTING;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule