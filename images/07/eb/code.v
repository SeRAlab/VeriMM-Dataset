module uart_transmitter (  
    input wire clk,  
    input wire [7:0] data_in,  
    input wire transmit_en,  
    output reg tx  
);  
    parameter BAUD_RATE = 9600;  
    parameter CLOCK_FREQ = 50000000;  
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;  
    reg [3:0] bit_index;  
    reg [9:0] shift_reg;  
    reg [15:0] counter;  
    reg transmitting;  

    always @(posedge clk) begin  
        if (transmit_en && !transmitting) begin  
            shift_reg <= {1'b1, data_in, 1'b0};  // Start bit + data + stop bit  
            bit_index <= 0;  
            counter <= 0;  
            transmitting <= 1;  
        end else if (transmitting) begin  
            counter <= counter + 1;  
            if (counter >= BIT_PERIOD - 1) begin  
                counter <= 0;  
                if (bit_index < 10) begin  
                    tx <= shift_reg[bit_index];  
                    bit_index <= bit_index + 1;  
                end else begin  
                    transmitting <= 0;  
                end  
            end  
        end  
    end  
endmodule