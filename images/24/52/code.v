module uart_transmitter (
    input wire clk,          // Clock input
    input wire start,        // Start transmission signal
    input wire [7:0] data,   // Data to be transmitted
    output reg tx           // Serial output line
);
    reg [3:0] bit_count;    // Counter for bits transmitted
    reg [7:0] shift_reg;    // Shift register for data
    reg sending;            // State to indicate if sending is ongoing

    initial begin
        tx = 1; // Idle state for TX line is high
        bit_count = 0;
        sending = 0;
    end

    always @(posedge clk) begin
        if (start && !sending) begin
            // Start sending the data
            shift_reg = data;
            bit_count = 0;
            sending = 1;
            tx = 0; // Start bit
        end else if (sending) begin
            if (bit_count < 8) begin
                // Transmit data bits
                tx = shift_reg[bit_count];
                bit_count = bit_count + 1;
            end else begin
                // Stop bit
                tx = 1;
                sending = 0; // Stop sending
            end
        end
    end
endmodule