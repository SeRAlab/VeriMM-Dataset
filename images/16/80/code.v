module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire transmit_enable,
    output reg tx,
    output reg transmission_complete
);
    parameter BAUD_RATE = 9600; // Fixed baud rate
    parameter CLOCK_FREQ = 50000000; // Example clock frequency
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;
    
    reg [3:0] bit_index;
    reg [15:0] counter;
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // Idle state for TX is high
            transmission_complete <= 0;
            bit_index <= 0;
            counter <= 0;
            transmitting <= 0;
        end else begin
            if (transmit_enable && !transmitting) begin
                transmitting <= 1;
                tx <= 0; // Start bit
                bit_index <= 0;
                counter <= 0;
                transmission_complete <= 0;
            end
            
            if (transmitting) begin
                if (counter < BIT_PERIOD - 1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    if (bit_index < 8) begin
                        tx <= data_in[bit_index]; // Send data bits
                        bit_index <= bit_index + 1;
                    end else if (bit_index == 8) begin
                        tx <= 1; // Stop bit
                        bit_index <= bit_index + 1;
                    end else begin
                        transmitting <= 0; // Transmission complete
                        transmission_complete <= 1;
                    end
                end
            end
        end
    end
endmodule