module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input start,  
    input recv,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, RECEIVE = 2'b01, TRANSMIT = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start)  
                        state <= TRANSMIT;  
                    else if (recv)  
                        state <= RECEIVE;  
                end  
                RECEIVE: begin  
                    if (start)  
                        state <= TRANSMIT;  
                    else  
                        state <= IDLE;  
                end  
                TRANSMIT: begin  
                    if (recv)  
                        state <= RECEIVE;  
                    else  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule