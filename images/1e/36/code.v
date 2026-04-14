module uart_transmitter(  
    input wire clk,  
    input wire rst,  
    input wire tx_en,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] bit_index;  
    reg [10:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tx <= 1; // idle state is high  
            bit_index <= 0;  
            shift_reg <= 11'b11111111111;  
        end else if (tx_en && bit_index == 0) begin  
            // Load the data into the shift register  
            shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit + data + start bit  
            bit_index <= 1;  
        end else if (bit_index > 0 && bit_index < 11) begin  
            tx <= shift_reg[bit_index];  
            bit_index <= bit_index + 1;  
        end else if (bit_index == 11) begin  
            tx <= 1; // go back to idle state  
            bit_index <= 0;  
        end  
    end  
endmodule