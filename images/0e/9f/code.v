module uart_transmitter(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input send,  
    output reg tx,  
    output reg busy  
);  
    reg [3:0] bit_count;  
    reg [10:0] shift_reg;  
    parameter BAUD_RATE = 9600; // Assuming clk is set appropriately for the baud rate  
    parameter CLK_FREQ = 50000000; // 50 MHz clock frequency  
    integer baud_cycles = CLK_FREQ / BAUD_RATE;  
    reg [15:0] clk_div;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            busy <= 0;  
            bit_count <= 0;  
            clk_div <= 0;  
        end else begin  
            if (busy) begin  
                if (clk_div < baud_cycles - 1) begin  
                    clk_div <= clk_div + 1;  
                end else begin  
                    clk_div <= 0;  
                    if (bit_count < 10) begin  
                        tx <= shift_reg[0];  
                        shift_reg <= {1'b0, shift_reg[10:1]}; // Shift right  
                        bit_count <= bit_count + 1;  
                    end else begin  
                        busy <= 0;  
                        bit_count <= 0;  
                    end  
                end  
            end else if (send) begin  
                busy <= 1;  
                shift_reg <= {1'b1, data_in, 1'b0}; // Start bit + data + stop bit  
                bit_count <= 0;  
                clk_div <= 0;  
            end  
        end  
    end  
endmodule