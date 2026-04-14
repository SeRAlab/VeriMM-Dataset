module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input valid,  
    input ack,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, RECEIVING = 2'b01, SENDING = 2'b10;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (valid)  
                        state <= RECEIVING;  
                end  
                RECEIVING: begin  
                    if (ack)  
                        state <= SENDING;  
                end  
                SENDING: begin  
                    // Assume we have some timeout logic here  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule