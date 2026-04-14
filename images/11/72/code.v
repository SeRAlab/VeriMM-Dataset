module uart_transmitter (  
    input wire clk,  
    input wire reset,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg busy  
);  
  
    parameter BAUD_RATE = 9600;  
    parameter CLK_FREQ = 50000000;  
    parameter BIT_PERIOD = CLK_FREQ / BAUD_RATE;  
  
    reg [3:0] bit_counter;  
    reg [15:0] clk_counter;  
    reg [8:0] shift_reg;  
  
    initial begin  
        tx = 1;  
        busy = 0;  
        bit_counter = 0;  
        clk_counter = 0;  
        shift_reg = 0;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            busy <= 0;  
            bit_counter <= 0;  
            clk_counter <= 0;  
        end else if (busy) begin  
            clk_counter <= clk_counter + 1;  
            if (clk_counter == BIT_PERIOD - 1) begin  
                clk_counter <= 0;  
                if (bit_counter < 10) begin  
                    tx <= shift_reg[0];  
                    shift_reg <= {1'b0, shift_reg[8:1]};  
                    bit_counter <= bit_counter + 1;  
                end else begin  
                    busy <= 0;  
                    bit_counter <= 0;  
                    tx <= 1;  
                end  
            end  
        end else if (start) begin  
            busy <= 1;  
            shift_reg <= {1'b1, data_in, 1'b0};  
        end  
    end  
endmodule