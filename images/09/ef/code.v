module uart_transmitter(  
    input wire clk,  
    input wire tx_enable,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] bit_index;  
    reg [8:0] shift_reg;  

    always @(posedge clk) begin  
        if (tx_enable) begin  
            if (bit_index < 9) begin  
                tx <= shift_reg[0];  
                shift_reg <= {1'b1, shift_reg[8:1]};  // Load stop bit (1) and shift  
                bit_index <= bit_index + 1;  
            end else begin  
                bit_index <= 0;  // Reset after full transmission  
                shift_reg <= {data_in, 1'b0};  // Load data and start bit (0)  
            end  
        end else begin  
            tx <= 1'b1;  // Idle state  
            bit_index <= 0;  
            shift_reg <= {data_in, 1'b0};  
        end  
    end  
endmodule