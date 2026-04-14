module uart_transmitter (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data_in,
    output reg tx,
    output reg ready
);
    reg [3:0] bit_index; // To track the current bit position
    reg [10:0] shift_reg; // 1 start + 8 data + 1 stop = 10 bits
    reg sending; // Flag to indicate if we are currently sending data

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1; // Idle state (high)
            ready <= 1; // Ready to send new data
            sending <= 0;
            bit_index <= 0;
        end else if (start && ready) begin
            shift_reg <= {1'b1, data_in, 1'b0}; // Load the shift register with stop bit and data
            tx <= 0; // Start bit
            sending <= 1; // Set sending flag
            bit_index <= 0; // Start from the first bit
            ready <= 0; // Not ready until done
        end else if (sending) begin
            if (bit_index < 10) begin
                tx <= shift_reg[bit_index]; // Shift out the next bit
                bit_index <= bit_index + 1; // Move to the next bit
            end else begin
                sending <= 0; // Finished sending
                tx <= 1; // Set tx back to idle state
                ready <= 1; // Ready to send new data
            end
        end
    end
endmodule