module UART_Controller(  
    input wire clk,  
    input wire send_en,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] bit_cnt;  
    reg [8:0] shift_reg; // 8 data bits + start bit + stop bit  
    reg sending;  
  
    always @(posedge clk) begin  
        if (send_en && !sending) begin  
            shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, Start bit  
            bit_cnt <= 0;  
            sending <= 1;  
        end else if (sending) begin  
            if (bit_cnt < 10) begin  
                tx <= shift_reg[0]; // Send LSB first  
                shift_reg <= shift_reg >> 1;  
                bit_cnt <= bit_cnt + 1;  
            end else begin  
                sending <= 0; // Transmission complete  
            end  
        end  
    end  
endmodule