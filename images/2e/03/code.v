module bluetooth_module (  
    input clk,  
    input reset,  
    input start,  
    input connected,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= CONNECTING;  
                end  
                CONNECTING: begin  
                    if (connected)  
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (~connected)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule