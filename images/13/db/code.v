module sata_controller (  
    input clk,  
    input rst_n,  
    input connect,  
    input send,  
    input disconnect,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               CONNECTED = 2'b01,  
               SENDING = 2'b10;  
               
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (connect) 
                        state <= CONNECTED;  
                end  
                CONNECTED: begin  
                    if (send) 
                        state <= SENDING;  
                    else if (disconnect)  
                        state <= IDLE;  
                end  
                SENDING: begin  
                    if (disconnect)  
                        state <= IDLE;  
                end  
                default:  
                    state <= IDLE;  
            endcase  
        end  
    end  
endmodule