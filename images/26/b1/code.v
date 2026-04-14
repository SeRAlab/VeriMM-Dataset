module uart_controller(  
    input wire clk,  
    input wire start,  
    input wire [7:0] data_in,  
    output reg tx  
);  
    parameter BAUD_RATE_DIV = 104; // Example value for 9600 baud with 1MHz clock  
    reg [6:0] bit_counter;  
    reg [7:0] data_buffer;  
    reg [6:0] baud_counter;  
    reg transmitting;  

    always @(posedge clk) begin  
        if (start && !transmitting) begin  
            transmitting <= 1;  
            data_buffer <= data_in;  
            bit_counter <= 0;  
            tx <= 0; // Start bit  
        end else if (transmitting) begin  
            if (baud_counter < BAUD_RATE_DIV) begin  
                baud_counter <= baud_counter + 1;  
            end else begin  
                baud_counter <= 0;  
                if (bit_counter < 8) begin  
                    tx <= data_buffer[bit_counter];  
                    bit_counter <= bit_counter + 1;  
                end else begin  
                    tx <= 1; // Stop bit  
                    transmitting <= 0;  
                end  
            end  
        end  
    end  
endmodule