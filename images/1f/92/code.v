module uart_transmitter(  
    input wire clk,  
    input wire reset,  
    input wire send,  
    input wire [7:0] data_in,  
    output reg tx,  
    output reg busy  
);  
    parameter CLK_DIV = 16; // Example clock division value for baud rate  
    reg [3:0] clk_count;  
    reg [3:0] bit_index;  
    reg [10:0] shift_reg;  
    reg sending;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            busy <= 0;  
            clk_count <= 0;  
            bit_index <= 0;  
            shift_reg <= 0;  
            sending <= 0;  
        end else if (send && !busy) begin  
            busy <= 1;  
            sending <= 1;  
            // Load shift register with start bit, data bits, and stop bit  
            shift_reg <= {1'b1, data_in, 1'b0}; // Start bit low, data, stop bit high  
            bit_index <= 0;  
            clk_count <= 0;  
        end else if (sending) begin  
            if (clk_count < CLK_DIV - 1) begin  
                clk_count <= clk_count + 1;  
            end else begin  
                clk_count <= 0;  
                tx <= shift_reg[bit_index];  
                if (bit_index < 10) begin  
                    bit_index <= bit_index + 1;  
                end else begin  
                    busy <= 0;  
                    sending <= 0;  
                end  
            end  
        end  
    end  
endmodule