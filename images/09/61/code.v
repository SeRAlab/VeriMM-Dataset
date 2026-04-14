module stop_and_wait_flow_control (  
    input wire clk,  
    input wire reset,  
    input wire send,  
    input wire ack,  
    output reg [7:0] data_out,  
    output reg busy  
);  

    reg state; // 0: waiting, 1: sending  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            data_out <= 8'b0;  
            busy <= 0;  
        end else begin  
            case (state)  
                0: begin // Waiting state  
                    if (send) begin  
                        data_out <= data_out + 1; // Increment data to send  
                        busy <= 1;  
                        state <= 1;  
                    end  
                end  
                1: begin // Sending state  
                    if (ack) begin  
                        busy <= 0;  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule