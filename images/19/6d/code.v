module dma_controller (  
    input clk,  
    input rst,  
    input req_chan0,  
    input req_chan1,  
    output reg ack_chan0,  
    output reg ack_chan1,  
    output reg [7:0] data_out  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, TRANSFER_CH0 = 2'b01, TRANSFER_CH1 = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ack_chan0 <= 0;  
            ack_chan1 <= 0;  
            data_out <= 8'h00;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack_chan0 <= 0;  
                    ack_chan1 <= 0;  
                    if (req_chan0) begin  
                        state <= TRANSFER_CH0;  
                    end else if (req_chan1) begin  
                        state <= TRANSFER_CH1;  
                    end  
                end  
                TRANSFER_CH0: begin  
                    ack_chan0 <= 1;  
                    ack_chan1 <= 0;  
                    data_out <= 8'hAA; // Example data  
                    state <= IDLE;  
                end  
                TRANSFER_CH1: begin  
                    ack_chan0 <= 0;  
                    ack_chan1 <= 1;  
                    data_out <= 8'hBB; // Example data  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule