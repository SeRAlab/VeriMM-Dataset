module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input receive,  
    input transmit,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, RECEIVE = 2'b01, TRANSMIT = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (receive)  
                        state <= RECEIVE;  
                    else if (transmit)  
                        state <= TRANSMIT;  
                end  
                RECEIVE: begin  
                    state <= IDLE;  
                end  
                TRANSMIT: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule