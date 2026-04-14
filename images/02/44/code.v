module uart_controller (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;
    reg rx_sync;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_out <= 0;
            data_valid <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx == 0) begin // Start bit detected
                        state <= START;
                    end
                end
                START: begin
                    if (bit_count == 4) begin // Wait for half a bit time
                        state <= DATA;
                        bit_count <= 0;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                DATA: begin
                    if (bit_count < 8) begin
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift in data
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= STOP; // Move to stop state after 8 bits
                        bit_count <= 0;
                    end
                end
                STOP: begin
                    if (bit_count == 4) begin // Wait for stop bit
                        data_out <= shift_reg;
                        data_valid <= 1; // Data is valid
                        state <= IDLE; // Go back to idle
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
            endcase
        end
    end
endmodule