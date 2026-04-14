module wifi_controller(  
    input clk,  
    input reset,  
    input start_connect,  
    input connection_done,  
    output reg [1:0] state  
);  

    // State encoding  
    parameter IDLE = 2'b00;  
    parameter CONNECTING = 2'b01;  
    parameter CONNECTED = 2'b10;  

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
                    if (connection_done)  
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    // Remain in CONNECTED state until reset  
                end  
            endcase  
        end  
    end  
endmodule