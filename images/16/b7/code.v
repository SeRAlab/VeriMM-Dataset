module wifi_controller (  
    input wire clk,  
    input wire connect,  
    input wire disconnect,  
    output reg [1:0] state  
);  
    // state encoding  
    parameter DISCONNECTED = 2'b00;  
    parameter CONNECTING = 2'b01;  
    parameter CONNECTED = 2'b10;  
    parameter DISCONNECTING = 2'b11;  

    always @(posedge clk) begin  
        case (state)  
            DISCONNECTED: begin  
                if (connect) state <= CONNECTING;  
            end  
            CONNECTING: begin  
                state <= CONNECTED;  
            end  
            CONNECTED: begin  
                if (disconnect) state <= DISCONNECTING;  
            end  
            DISCONNECTING: begin  
                state <= DISCONNECTED;  
            end  
            default: state <= DISCONNECTED;  
        endcase  
    end  
endmodule