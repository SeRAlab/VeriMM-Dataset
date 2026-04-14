module temperature_monitor (  
    input clk,  
    input reset,  
    input [3:0] temperature,  
    output reg alert  
);  
    reg [1:0] state;  
    parameter IDLE = 2'b00, ALERT_ON = 2'b01, ALERT_OFF = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            alert <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (temperature > 4'b1010) begin // 10 in decimal  
                        alert <= 1;  
                        state <= ALERT_ON;  
                    end  
                end  
                ALERT_ON: begin  
                    if (alert) begin  
                        state <= ALERT_OFF;  
                    end  
                end  
                ALERT_OFF: begin  
                    alert <= 0;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule