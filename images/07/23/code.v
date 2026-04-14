module stop_and_wait(  
    input clk,  
    input reset,  
    input send,  
    input ack,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg busy  
);  
    reg state; // 0: idle, 1: transmitting  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            data_out <= 8'b0;  
            busy <= 0;  
        end else begin  
            case (state)  
                0: begin // idle state  
                    if (send) begin  
                        data_out <= data_in;  
                        busy <= 1;  
                        state <= 1;  
                    end  
                end  
                1: begin // transmitting state  
                    if (ack) begin  
                        busy <= 0;  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule