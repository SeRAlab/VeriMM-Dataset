module wifi_controller(  
    input wire clk,  
    input wire reset,  
    input wire connect,  
    input wire disconnect,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter CONNECTED = 2'b01;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (connect) state <= CONNECTED;  
                CONNECTED: if (disconnect) state <= IDLE;  
            endcase  
        end  
    end  
endmodule