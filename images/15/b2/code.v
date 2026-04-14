module spi_controller  
(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg sclk,  
    output reg mosi,  
    output reg cs,  
    output reg done  
);  

    reg [2:0] state;  
    reg [2:0] bit_count;  

    localparam IDLE = 3'b000,  
               START = 3'b001,  
               TRANSMIT = 3'b010,  
               COMPLETE = 3'b011;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            sclk <= 0;  
            mosi <= 0;  
            cs <= 1;  
            done <= 0;  
            bit_count <= 3'b000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    cs <= 1;  
                    done <= 0;  
                    if (start) begin  
                        cs <= 0;  
                        state <= START;  
                    end  
                end  

                START: begin  
                    sclk <= 0;  
                    mosi <= data_in[7];  
                    state <= TRANSMIT;  
                    bit_count <= 3'b000;  
                end  

                TRANSMIT: begin  
                    if (bit_count < 3'b111) begin  
                        sclk <= ~sclk;  
                        if (sclk) begin  
                            bit_count <= bit_count + 1;  
                            mosi <= data_in[7 - bit_count];  
                        end  
                    end else begin  
                        state <= COMPLETE;  
                    end  
                end  

                COMPLETE: begin  
                    sclk <= 0;  
                    cs <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule