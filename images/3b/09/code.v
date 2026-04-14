module SPI_Controller (  
    input wire clk,  
    input wire rst,  
    input wire cs,  
    input wire mosi,  
    output reg miso,  
    output reg done,  
    output reg [7:0] data_out  
);  
    reg [2:0] bit_cnt;  
    reg [7:0] data_in;  
    reg state;  
    localparam IDLE = 1'b0,  
               SHIFT = 1'b1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            bit_cnt <= 3'b000;  
            data_in <= 8'b0;  
            miso <= 1'b0;  
            done <= 1'b0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (!cs) begin  
                        state <= SHIFT;  
                        bit_cnt <= 3'b000;  
                        done <= 1'b0;  
                    end  
                end  
                SHIFT: begin  
                    if (bit_cnt < 3'b111) begin  
                        data_in <= {data_in[6:0], mosi};  
                        miso <= data_out[7-bit_cnt];  
                        bit_cnt <= bit_cnt + 1;  
                    end else begin  
                        state <= IDLE;  
                        done <= 1'b1;  
                        data_out <= data_in;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule