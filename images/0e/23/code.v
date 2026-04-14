module spi_master(  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg mosi,  
    output reg sclk,  
    output reg cs,  
    output reg done  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  
    reg state;  

    parameter IDLE = 1'b0;  
    parameter TRANSMIT = 1'b1;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            mosi <= 0;  
            sclk <= 0;  
            cs <= 1;  
            done <= 0;  
            bit_count <= 0;  
            shift_reg <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    cs <= 1;  
                    done <= 0;  
                    if (start) begin  
                        shift_reg <= data_in;  
                        cs <= 0;  
                        bit_count <= 7;  
                        state <= TRANSMIT;  
                    end  
                end  
                TRANSMIT: begin  
                    sclk <= ~sclk;  
                    if (sclk) begin  
                        mosi <= shift_reg[bit_count];  
                        if (bit_count == 0) begin  
                            cs <= 1;  
                            done <= 1;  
                            state <= IDLE;  
                        end else begin  
                            bit_count <= bit_count - 1;  
                        end  
                    end  
                end  
            endcase  
        end  
    end  
endmodule