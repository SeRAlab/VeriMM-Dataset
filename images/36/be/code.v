module uart_transmitter(  
    input clk,            // Clock input  
    input rst,            // Reset input  
    input tx_start,       // Start transmission signal  
    input [7:0] data_in,  // 8-bit data input  
    output reg tx_out     // Transmitted data output  
);  
    reg [3:0] bit_index;  // Current bit index  
    reg [10:0] shift_reg; // Shift register for transmission  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tx_out <= 1;  // Idle state is high  
            bit_index <= 0;  
            shift_reg <= 11'b11111111111; // Default to idle state  
        end else if (tx_start) begin  
            shift_reg <= {1'b1, data_in, 1'b0}; // Start with stop bit, data, start bit  
            bit_index <= 0;  
        end else if (bit_index < 10) begin  
            tx_out <= shift_reg[bit_index];  
            bit_index <= bit_index + 1;  
        end  
    end  
endmodule