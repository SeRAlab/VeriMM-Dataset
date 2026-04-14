module wifi_module (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire success,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              CONNECTING = 2'b01,  
              CONNECTED = 2'b10;  

    // State transition  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= CONNECTING;  
                CONNECTING: if (success) state <= CONNECTED;  
                CONNECTED: if (!success) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule