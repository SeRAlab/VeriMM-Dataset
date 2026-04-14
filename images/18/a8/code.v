module uart_transmitter (
    input [7:0] data_in,
    input start_tx,
    input clk,
    input baud_rate,
    output reg tx_line
);
    reg [3:0] state;
    reg [9:0] shift_reg;
    reg [12:0] baud_counter; // Adjust size based on baud rate
    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx_line <= 1; // Idle state is high
                if (start_tx) begin
                    shift_reg <= {1'b1, data_in, 1'b0}; // Stop, data, start
                    state <= START;
                    baud_counter <= 0; // Reset baud counter
                end
            end
            START: begin
                if (baud_counter == baud_rate) begin
                    tx_line <= shift_reg[0]; // Send start bit
                    shift_reg <= shift_reg >> 1; // Shift right
                    baud_counter <= 0;
                    state <= DATA;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            DATA: begin
                if (baud_counter == baud_rate) begin
                    tx_line <= shift_reg[0]; // Send data bits
                    shift_reg <= shift_reg >> 1; // Shift right
                    baud_counter <= 0;
                    if (shift_reg[8]) state <= STOP; // Check if data is done
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
            STOP: begin
                if (baud_counter == baud_rate) begin
                    tx_line <= 1; // Send stop bit
                    state <= IDLE;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        endcase
    end
endmodule