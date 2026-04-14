module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input start_tx,  
    input start_rx,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               TRANSMIT = 2'b01,  
               RECEIVE = 2'b10;  
     
    // Sequential logic for state transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (start_tx)  
                        state <= TRANSMIT;  
                    else if (start_rx)  
                        state <= RECEIVE;  
                end  
                TRANSMIT: begin  
                    if (!start_tx)  
                        state <= IDLE;  
                end  
                RECEIVE: begin  
                    if (!start_rx)  
                        state <= IDLE;  
                end  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule