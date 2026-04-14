module UART_Controller (  
    input wire clk,  
    input wire reset,  
    input wire transmit_enable,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    reg [3:0] bit_index;  
    reg [7:0] shift_reg;  
    reg transmitting;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            bit_index <= 0;  
            shift_reg <= 0;  
            transmitting <= 0;  
        end else begin  
            if (transmit_enable && !transmitting) begin  
                shift_reg <= data_in;  
                bit_index <= 0;  
                transmitting <= 1;  
                tx <= 0; // Start bit  
            end else if (transmitting) begin  
                if (bit_index < 8) begin  
                    tx <= shift_reg[bit_index];  
                    bit_index <= bit_index + 1;  
                end else begin  
                    tx <= 1; // Stop bit  
                    transmitting <= 0;  
                end  
            end  
        end  
    end  
endmodule