module uart_controller (
    input clk,
    input start,
    input [7:0] data_in,
    output reg tx,
    output reg ready
);
    reg [3:0] bit_index;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg transmitting;

    always @(posedge clk) begin
        if (start && !transmitting) begin
            transmitting <= 1;
            bit_index <= 0;
            shift_reg <= {1'b1, data_in, 1'b0}; // Prepare shift register (start bit = 0, stop bit = 1)
            ready <= 0;
        end else if (transmitting) begin
            tx <= shift_reg[0]; // Transmit the current bit
            shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right
            bit_index <= bit_index + 1;

            if (bit_index == 10) begin
                transmitting <= 0; // Transmission complete
                ready <= 1;
            end
        end
    end

    initial begin
        tx <= 1; // Idle state
        ready <= 1; // Ready initially
    end
endmodule