module ethernet_mac_controller (  
    input clk,  
    input reset,  
    input start,  
    input done,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00,  
              TRANSMITTING = 2'b01,  
              WAITING = 2'b10;  
              
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= TRANSMITTING;  
                end  
                TRANSMITTING: begin  
                    if (done)  
                        state <= WAITING;  
                end  
                WAITING: begin  
                    if (done)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule