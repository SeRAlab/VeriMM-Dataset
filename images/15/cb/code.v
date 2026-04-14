module StopAndWaitProtocol (  
    input wire clk,  
    input wire reset,  
    input wire send,  
    input wire data_in,  
    output reg data_out,  
    output reg ack  
);  
    reg state; // 0 = idle, 1 = sending  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            data_out <= 0;  
            ack <= 0;  
        end else begin  
            case (state)  
                0: begin // Idle state  
                    if (send) begin  
                        data_out <= data_in;  
                        state <= 1;  
                        ack <= 0;  
                    end  
                end  
                1: begin // Sending state  
                    ack <= 1; // Assume ACK is received  
                    state <= 0;  
                end  
            endcase  
        end  
    end  
endmodule