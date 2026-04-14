module i2c_controller(  
    input clk,  
    input rst,  
    input [6:0] addr,  
    input [7:0] data_in,  
    input start,  
    input rw,  // 1 for read, 0 for write  
    output reg sda,  
    output reg scl,  
    output reg ready  
);  
    reg [3:0] state;  
    parameter IDLE = 4'b0000, START = 4'b0001, ADDRESS = 4'b0010, ACK_ADDR = 4'b0011, DATA = 4'b0100, ACK_DATA = 4'b0101, STOP = 4'b0110;  
    integer bit_cnt;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            sda <= 1;  
            scl <= 1;  
            ready <= 0;  
            bit_cnt <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        sda <= 0;  // Start condition  
                        state <= START;  
                        ready <= 0;  
                    end  
                end  
                START: begin  
                    scl <= 0;  
                    state <= ADDRESS;  
                    bit_cnt <= 0;  
                end  
                ADDRESS: begin  
                    sda <= addr[6 - bit_cnt];  
                    scl <= 1;  
                    state <= (bit_cnt == 6) ? ACK_ADDR : ADDRESS;  
                    bit_cnt <= bit_cnt + 1;  
                end  
                ACK_ADDR: begin  
                    scl <= 0;  
                    sda <= 1;  // Release SDA for ACK  
                    scl <= 1;  
                    state <= (rw == 0) ? DATA : STOP;  
                end  
                DATA: begin  
                    sda <= data_in[7 - bit_cnt];  
                    scl <= 1;  
                    state <= (bit_cnt == 7) ? ACK_DATA : DATA;  
                    bit_cnt <= bit_cnt + 1;  
                end  
                ACK_DATA: begin  
                    scl <= 0;  
                    sda <= 1;  // Release SDA for ACK  
                    scl <= 1;  
                    state <= STOP;  
                end  
                STOP: begin  
                    sda <= 0;  
                    scl <= 1;  
                    sda <= 1;  // Stop condition  
                    ready <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule