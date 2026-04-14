module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input start_receive,  
    input start_transmit,  
    output reg [1:0] state  
);  

    // State definitions  
    parameter IDLE = 2'b00,  
              RECEIVING = 2'b01,  
              TRANSMITTING = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_receive)  
                        state <= RECEIVING;  
                    else if (start_transmit)  
                        state <= TRANSMITTING;  
                end  
                RECEIVING: begin  
                    if (start_transmit)  
                        state <= TRANSMITTING;  
                    else if (!start_receive)  
                        state <= IDLE;  
                end  
                TRANSMITTING: begin  
                    if (start_receive)  
                        state <= RECEIVING;  
                    else if (!start_transmit)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule