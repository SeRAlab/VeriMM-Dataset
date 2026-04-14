module uart_transmitter (
    input wire clk,
    input wire [7:0] data_in,
    input wire start,
    input wire tx_enable,
    output reg tx_out
);
    reg [3:0] bit_count;
    reg [9:0] shift_reg;
    reg transmitting;

    always @(posedge clk) begin
        if (start && tx_enable && !transmitting) begin
            transmitting <= 1;
            shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit, data, start bit
            bit_count <= 0;
        end
        else if (transmitting) begin
            if (bit_count < 10) begin
                tx_out <= shift_reg[0]; // Send out the least significant bit
                shift_reg <= shift_reg >> 1; // Shift right
                bit_count <= bit_count + 1;
            end else begin
                transmitting <= 0; // Transmission done
                tx_out <= 1; // Idle state
            end
        end
    end
endmodule