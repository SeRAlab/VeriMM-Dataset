module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input start_receive,  
    input start_send,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00;  
    parameter RECEIVING = 2'b01;  
    parameter SENDING = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_receive)  
                        state <= RECEIVING;  
                    else if (start_send)  
                        state <= SENDING;  
                end  
                RECEIVING: begin  
                    if (!start_receive)  
                        state <= IDLE;  
                end  
                SENDING: begin  
                    if (!start_send)  
                        state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule