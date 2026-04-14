module uart_receiver (  
    input clk,  
    input rst,  
    input rx,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    parameter BAUD_RATE = 9600;  
    parameter CLOCK_FREQ = 50000000;  
    parameter BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;  
    reg [3:0] bit_count;  
    reg [15:0] clk_div;  
    reg state;  
    reg [7:0] buffer;  

    localparam IDLE = 1'b0;  
    localparam RECEIVING = 1'b1;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            bit_count <= 0;  
            clk_div <= 0;  
            data_ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    data_ready <= 0;  
                    if (rx == 0) begin  
                        state <= RECEIVING;  
                        clk_div <= 0;  
                        bit_count <= 0;  
                    end  
                end  
                RECEIVING: begin  
                    if (clk_div < BIT_PERIOD - 1) begin  
                        clk_div <= clk_div + 1;  
                    end else begin  
                        clk_div <= 0;  
                        if (bit_count < 8) begin  
                            buffer[bit_count] <= rx;  
                            bit_count <= bit_count + 1;  
                        end else begin  
                            data_out <= buffer;  
                            data_ready <= 1;  
                            state <= IDLE;  
                        end  
                    end  
                end  
            endcase  
        end  
    end  
endmodule