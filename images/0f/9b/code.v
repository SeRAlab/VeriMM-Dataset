module wifi_state_machine(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire connect,  
    output reg [1:0] state  
);  

    // State encoding  
    parameter IDLE = 2'b00,  
              SCANNING = 2'b01,  
              CONNECTING = 2'b10,  
              CONNECTED = 2'b11;  

    // State transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= SCANNING;  
                SCANNING: if (connect) state <= CONNECTING;  
                CONNECTING: state <= CONNECTED;  
                CONNECTED: state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule