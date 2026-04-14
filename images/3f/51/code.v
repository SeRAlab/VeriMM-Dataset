module spi_master(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input start,  
    output reg mosi,  
    output reg sck,  
    output reg cs,  
    output reg done  
);  
    reg [3:0] state;  
    reg [2:0] bit_count;  
  
    localparam IDLE = 4'b0000,  
               START = 4'b0001,  
               SHIFT = 4'b0010,  
               DONE = 4'b0011;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            cs <= 1;  
            mosi <= 0;  
            sck <= 0;  
            done <= 0;  
            bit_count <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start) begin  
                        cs <= 0;  
                        state <= START;  
                    end  
                end  
                START: begin  
                    bit_count <= 0;  
                    state <= SHIFT;  
                end  
                SHIFT: begin  
                    if (bit_count < 8) begin  
                        mosi <= data_in[7 - bit_count];  
                        sck <= 1;  
                        bit_count <= bit_count + 1;  
                        state <= (bit_count == 7) ? DONE : SHIFT;  
                    end  
                end  
                DONE: begin  
                    sck <= 0;  
                    cs <= 1;  
                    done <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule