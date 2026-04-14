module uart_transmitter (
    input wire clk,          // System clock
    input wire rst_n,       // Active low reset
    input wire send,        // Signal to send data
    input wire [7:0] data_in, // 8-bit parallel data input
    output reg tx,          // Transmit output
    output reg busy         // Busy signal
);

    parameter BAUD_RATE_DIV = 104; // Assuming a clock frequency of 1MHz for 9600 baud
    reg [3:0] bit_counter;   // Counter for the bits
    reg [10:0] shift_reg;    // Shift register for the data
    reg [6:0] clk_counter;    // Clock divider counter
    reg transmitting;        // Transmission state

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1;        // Idle state is high
            busy <= 0;
            transmitting <= 0;
            bit_counter <= 0;
            clk_counter <= 0;
            shift_reg <= 0;
        end else if (send && !busy) begin
            // Start transmission
            busy <= 1;
            transmitting <= 1;
            shift_reg <= {1'b1, data_in, 1'b0}; // Adding stop and start bits
            bit_counter <= 0;
            clk_counter <= 0;
        end else if (transmitting) begin
            if (clk_counter < BAUD_RATE_DIV) begin
                clk_counter <= clk_counter + 1;
            end else begin
                clk_counter <= 0;
                tx <= shift_reg[bit_counter]; // Shift out the data bit
                if (bit_counter < 10) begin
                    bit_counter <= bit_counter + 1;
                end else begin
                    busy <= 0; // Transmission complete
                    transmitting <= 0;
                end
            end
        end
    end
endmodule