module wifi_controller(  
    input wire clk,  
    input wire connect,  
    input wire disconnect,  
    output reg [1:0] state  
);  
    parameter DISCONNECTED = 2'b00;  
    parameter CONNECTING = 2'b01;  
    parameter CONNECTED = 2'b10;  

    always @(posedge clk) begin  
        case(state)  
            DISCONNECTED: begin  
                if(connect)  
                    state <= CONNECTING;  
            end  
            CONNECTING: begin  
                if(disconnect)  
                    state <= DISCONNECTED;  
                else  
                    state <= CONNECTED;  
            end  
            CONNECTED: begin  
                if(disconnect)  
                    state <= DISCONNECTED;  
            end  
            default: state <= DISCONNECTED;  
        endcase  
    end  
endmodule