module uart_receiver(
    input wire clk,
    input wire rst,
    input wire rx, // UART input
    output reg [7:0] data_out,
    output reg valid
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] bit_count; // To count the received bits
    reg [7:0] shift_reg; // To hold the received bits

    // State transition based on the clock
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            valid <= 0;
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                valid = 0;
                if (rx == 0) // Start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                next_state = DATA; // Move to DATA state after detecting start bit
            end
            DATA: begin
                if (bit_count < 8) begin
                    next_state = DATA; // Continue receiving data
                end else begin
                    next_state = STOP; // Move to STOP state after 8 bits
                end
            end
            STOP: begin
                valid = 1; // Data is valid
                next_state = IDLE; // Go back to IDLE
            end
            default: next_state = IDLE;
        endcase
    end

    // Data reception logic
    always @(posedge clk) begin
        if (state == DATA) begin
            shift_reg <= {rx, shift_reg[7:1]}; // Shift in new data bit
            bit_count <= bit_count + 1; // Increment bit count
        end else if (state == STOP) begin
            data_out <= shift_reg; // Output the received data
            bit_count <= 0; // Reset bit count
        end else if (state == IDLE) begin
            bit_count <= 0; // Reset bit count in IDLE state
        end
    end
endmodule