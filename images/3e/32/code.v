module uart_transmitter (  
    input wire clk,  
    input wire rst,  
    input wire tx_enable,  
    input wire [7:0] data_in,  
    output reg tx_out  
);  
    reg [3:0] bit_count;  
    reg [9:0] shift_reg;  
    reg transmitting;  
    reg [15:0] baud_counter;  
    parameter BAUD_RATE = 5208; // Adjust for your clock speed  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tx_out <= 1;  
            bit_count <= 0;  
            shift_reg <= 0;  
            transmitting <= 0;  
            baud_counter <= 0;  
        end else begin  
            if (tx_enable && !transmitting) begin  
                transmitting <= 1;  
                shift_reg <= {1'b1, data_in, 1'b0}; // Prepare start bit (0) + data + stop bit (1)  
                bit_count <= 0;  
            end  
            if (transmitting) begin  
                baud_counter <= baud_counter + 1;  
                if (baud_counter == BAUD_RATE) begin  
                    baud_counter <= 0;  
                    tx_out <= shift_reg[bit_count];  
                    bit_count <= bit_count + 1;  
                    if (bit_count == 10) begin  
                        transmitting <= 0;  
                    end  
                end  
            end  
        end  
    end  
endmodule