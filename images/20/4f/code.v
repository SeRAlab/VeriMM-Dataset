module SPI_Master (  
    input wire clk,             // System clock  
    input wire rst_n,           // Active low reset  
    input wire start,           // Start signal for transmission  
    input wire [7:0] data_in,   // Data to send  
    output reg mosi,            // Master Out Slave In  
    output reg sck,             // Serial Clock  
    output reg ss,              // Slave Select  
    input wire miso             // Master In Slave Out  
);  
    reg [2:0] state;  
    reg [2:0] bit_cnt;  

    parameter IDLE    = 3'b000,  
              START   = 3'b001,  
              TRANSFER = 3'b010,  
              STOP    = 3'b011;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            state <= IDLE;  
            mosi <= 0;  
            sck <= 0;  
            ss <= 1;  
            bit_cnt <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    ss <= 1;  
                    if (start) begin  
                        state <= START;  
                    end  
                end  

                START: begin  
                    ss <= 0;  
                    bit_cnt <= 0;  
                    state <= TRANSFER;  
                end  

                TRANSFER: begin  
                    if (bit_cnt < 8) begin  
                        mosi <= data_in[7 - bit_cnt];  
                        sck <= ~sck; // Toggle clock  
                        if (sck) begin  
                            bit_cnt <= bit_cnt + 1;  
                        end  
                    end else begin  
                        state <= STOP;  
                    end  
                end  

                STOP: begin  
                    ss <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule