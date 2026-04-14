module DMA_Controller (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] req,  
    output reg [3:0] ack,  
    output reg [7:0] data  
);  
    reg [1:0] state;  
    reg [1:0] channel;  

    parameter IDLE = 2'b00,  
              ACTIVE = 2'b01,  
              ACKNOWLEDGE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            ack <= 4'b0000;  
            data <= 8'b00000000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ack <= 4'b0000;  
                    if (req != 4'b0000) begin  
                        channel <= req[3] ? 3 : (req[2] ? 2 : (req[1] ? 1 : 0));  
                        state <= ACTIVE;  
                    end  
                end  
                ACTIVE: begin  
                    ack[channel] <= 1;  
                    data <= 8'hFF; // Example data transfer  
                    state <= ACKNOWLEDGE;  
                end  
                ACKNOWLEDGE: begin  
                    if (ack[channel]) begin  
                        ack[channel] <= 0;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule