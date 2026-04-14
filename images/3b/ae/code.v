module uart_transmitter (  
    input wire clk,  
    input wire enable,  
    input wire [7:0] data,  
    output reg tx  
);  

    reg [3:0] bit_index;  
    reg [9:0] shift_reg;  
    reg transmitting;  

    always @(posedge clk) begin  
        if (enable && !transmitting) begin  
            transmitting <= 1;  
            bit_index <= 0;  
            shift_reg <= {1'b1, data, 1'b0}; // Start bit (0), data, stop bit (1)  
        end  
        else if (transmitting) begin  
            tx <= shift_reg[0];  
            shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right  
            bit_index <= bit_index + 1;  
            if (bit_index == 9) begin  
                transmitting <= 0;  
            end  
        end  
    end  
endmodule