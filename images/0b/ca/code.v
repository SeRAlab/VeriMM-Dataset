module arq_system (  
    input wire clk,  
    input wire reset,  
    input wire data_valid,  
    input wire [7:0] data_in,  
    input wire error_detected,  
    output reg [7:0] data_out,  
    output reg ack,  
    output reg request_retransmit  
);  
    reg [7:0] received_data;  
    reg state; // 0: waiting, 1: sending ack  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 0;  
            ack <= 0;  
            request_retransmit <= 0;  
            data_out <= 8'b0;  
        end else begin  
            case (state)  
                0: begin // Waiting for data  
                    if (data_valid) begin  
                        received_data <= data_in;  
                        if (error_detected) begin  
                            request_retransmit <= 1;  
                            ack <= 0;  
                        end else begin  
                            data_out <= received_data;  
                            ack <= 1;  
                            request_retransmit <= 0;  
                        end  
                        state <= 1;  
                    end  
                end  
                1: begin // Sending ack  
                    if (ack) begin  
                        state <= 0;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule