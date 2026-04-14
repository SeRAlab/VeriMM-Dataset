module uart_transmitter  
(  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input send,  
    output reg tx  
);  
    parameter BAUD_RATE = 9600;  
    parameter CLOCK_FREQ = 50000000;  
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;  
    reg [3:0] bit_count;  
    reg [15:0] clk_count;  
    reg sending;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            tx <= 1;  
            bit_count <= 0;  
            clk_count <= 0;  
            sending <= 0;  
        end else if (send && !sending) begin  
            sending <= 1;  
            tx <= 0; // Start bit  
            bit_count <= 0;  
            clk_count <= 0;  
        end else if (sending) begin  
            if (clk_count < BIT_PERIOD - 1) begin  
                clk_count <= clk_count + 1;  
            end else begin  
                clk_count <= 0;  
                if (bit_count < 8) begin  
                    tx <= data_in[bit_count]; // Transmit data bits  
                    bit_count <= bit_count + 1;  
                end else if (bit_count == 8) begin  
                    tx <= 1; // Stop bit  
                    bit_count <= bit_count + 1;  
                end else begin  
                    sending <= 0; // Transmission complete  
                end  
            end  
        end  
    end  
endmodule