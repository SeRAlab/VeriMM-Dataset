module uart_receiver #(parameter BAUD_RATE = 9600, parameter CLOCK_FREQ = 50000000)  
(  
    input wire clk,  
    input wire rst,  
    input wire rx,  
    output reg [7:0] data_out,  
    output reg data_ready  
);  
    parameter CLOCK_DIV = CLOCK_FREQ / BAUD_RATE;  
    reg [3:0] state;  
    reg [12:0] baud_count;  
    reg [2:0] bit_index;  
    reg [7:0] shift_reg;  

    localparam IDLE = 0, START = 1, DATA = 2, STOP = 3;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            baud_count <= 0;  
            bit_index <= 0;  
            data_out <= 0;  
            data_ready <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    data_ready <= 0;  
                    if (!rx) begin  
                        state <= START;  
                        baud_count <= 0;  
                    end  
                end  
                START: begin  
                    if (baud_count < CLOCK_DIV / 2)  
                        baud_count <= baud_count + 1;  
                    else begin  
                        baud_count <= 0;  
                        state <= DATA;  
                        bit_index <= 0;  
                    end  
                end  
                DATA: begin  
                    if (baud_count < CLOCK_DIV)  
                        baud_count <= baud_count + 1;  
                    else begin  
                        baud_count <= 0;  
                        shift_reg[bit_index] <= rx;  
                        bit_index <= bit_index + 1;  
                        if (bit_index == 7)  
                            state <= STOP;  
                    end  
                end  
                STOP: begin  
                    if (baud_count < CLOCK_DIV)  
                        baud_count <= baud_count + 1;  
                    else begin  
                        data_out <= shift_reg;  
                        data_ready <= 1;  
                        state <= IDLE;  
                    end  
                end  
            endcase  
        end  
    end  
endmodule