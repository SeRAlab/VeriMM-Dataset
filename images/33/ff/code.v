module uart_tx(
    input wire clk,
    input wire start,
    input wire [7:0] data,
    output reg tx_out
);
    reg [3:0] bit_count; // Counts number of bits sent
    reg [7:0] shift_reg; // Shift register for data
    reg sending; // Indicates if sending is in progress

    always @(posedge clk) begin
        if (start && !sending) begin
            sending <= 1; // Start sending
            shift_reg <= data; // Load data into shift register
            bit_count <= 0; // Reset bit count
            tx_out <= 0; // Start bit
        end else if (sending) begin
            if (bit_count < 8) begin
                tx_out <= shift_reg[bit_count]; // Send the next bit
                bit_count <= bit_count + 1; // Increment bit count
            end else begin
                tx_out <= 1; // Stop bit
                sending <= 0; // Stop sending
            end
        end
    end
endmodule