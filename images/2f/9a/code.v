module spi_master_controller (  
    input clk,  
    input rst,  
    input start,  
    input [7:0] data_out,  
    input miso,  
    output reg mosi,  
    output reg sclk,  
    output reg cs,  
    output reg [7:0] data_in,  
    output reg done  
);  
    
    reg [2:0] state;  
    reg [2:0] bit_cnt;  
    reg [7:0] shift_reg;  

    localparam IDLE = 3'b000,  
               START = 3'b001,  
               TRANSFER = 3'b010,  
               DONE = 3'b011;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            mosi <= 1'b0;  
            sclk <= 1'b0;  
            cs <= 1'b1;  
            data_in <= 8'b0;  
            done <= 1'b0;  
            bit_cnt <= 3'b000;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        cs <= 1'b0;  
                        shift_reg <= data_out;  
                        state <= START;  
                        bit_cnt <= 3'b0;  
                        done <= 1'b0;  
                    end  
                end  
                START: begin  
                    sclk <= 1'b0;  
                    state <= TRANSFER;  
                end  
                TRANSFER: begin  
                    if (bit_cnt < 3'b111) begin  
                        sclk <= 1'b1;  
                        mosi <= shift_reg[7];  
                        data_in[bit_cnt] <= miso;  
                        shift_reg <= {shift_reg[6:0], 1'b0};  
                        bit_cnt <= bit_cnt + 1;  
                        state <= START;  
                    end else begin  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    sclk <= 1'b0;  
                    cs <= 1'b1;  
                    done <= 1'b1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule