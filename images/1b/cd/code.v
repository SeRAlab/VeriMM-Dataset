module stop_and_wait (  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    output reg ready_to_send,  
    output reg data_sent  
);  
    reg state; // 0: waiting, 1: sending  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            ready_to_send <= 1;  
            data_sent <= 0;  
        end else begin  
            case (state)  
                0: begin // waiting  
                    if (send) begin  
                        state <= 1;  
                        ready_to_send <= 0;  
                        data_sent <= 1;  
                    end  
                end  
                1: begin // sending  
                    if (ack) begin  
                        state <= 0;  
                        ready_to_send <= 1;  
                        data_sent <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule