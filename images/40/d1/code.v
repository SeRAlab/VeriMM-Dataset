module spi_master (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg mosi,  
    output reg sclk,  
    output reg transfer_done  
);  
    reg [2:0] bit_count;  
    reg state; // 0: idle, 1: sending  
    parameter IDLE = 1'b0, SENDING = 1'b1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            mosi <= 1'b0;  
            sclk <= 1'b0;  
            transfer_done <= 1'b0;  
            bit_count <= 3'b000;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        bit_count <= 3'b000;  
                        state <= SENDING;  
                        transfer_done <= 1'b0;  
                    end  
                end  
                SENDING: begin  
                    if (bit_count < 3'b111) begin  
                        sclk <= ~sclk;  
                        if (sclk) begin  
                            mosi <= data_in[7 - bit_count];  
                            bit_count <= bit_count + 1;  
                        end  
                    end else begin  
                        state <= IDLE;  
                        transfer_done <= 1'b1;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule