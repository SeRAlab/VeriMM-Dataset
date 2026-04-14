module uart_receiver (
    input wire clk,
    input wire reset,
    input wire serial_in,
    output reg [7:0] data_out,
    output reg data_ready
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // Assuming a 50 MHz clock
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_count;
    reg [15:0] clock_counter;
    reg [7:0] shift_reg;
    reg receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            clock_counter <= 0;
            shift_reg <= 0;
            receiving <= 0;
            data_ready <= 0;
        end else begin
            if (receiving) begin
                if (clock_counter < BIT_PERIOD - 1) begin
                    clock_counter <= clock_counter + 1;
                end else begin
                    clock_counter <= 0;
                    if (bit_count < 8) begin
                        shift_reg <= {serial_in, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        data_out <= shift_reg;
                        data_ready <= 1;
                        receiving <= 0;
                    end
                end
            end else begin
                if (serial_in == 0) begin // Start bit detected
                    receiving <= 1;
                    bit_count <= 0;
                    clock_counter <= 0;
                    data_ready <= 0;
                end
            end
        end
    end
endmodule