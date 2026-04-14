module wifi_state_machine (  
    input wire clk,  
    input wire reset,  
    input wire wifi_request,  
    input wire disconnect_request,  
    output reg [1:0] current_state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               CONNECTING = 2'b01,  
               CONNECTED = 2'b10,  
               DISCONNECTED = 2'b11;  
               
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_state <= IDLE;  
        end else begin  
            case (current_state)  
                IDLE: begin  
                    if (wifi_request)  
                        current_state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    current_state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (disconnect_request)  
                        current_state <= DISCONNECTED;  
                end  
                DISCONNECTED: begin  
                    current_state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule