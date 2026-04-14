module ethernet_mac_controller(  
    input wire clk,  
    input wire reset,  
    input wire start_tx,  
    input wire start_rx,  
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter TRANSMIT = 2'b01;  
    parameter RECEIVE = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_tx)  
                        state <= TRANSMIT;  
                    else if (start_rx)  
                        state <= RECEIVE;  
                end  
                TRANSMIT: begin  
                    // Assume transmission is one clock cycle  
                    state <= IDLE;  
                end  
                RECEIVE: begin  
                    // Assume reception is one clock cycle  
                    state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule