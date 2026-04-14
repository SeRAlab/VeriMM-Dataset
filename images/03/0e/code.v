module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire [7:0] data_in,
    output reg tx,
    output reg ready
);

    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_count;
    reg [15:0] counter;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    reg transmitting;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1; // idle high
            ready <= 1;
            bit_count <= 0;
            counter <= 0;
            transmitting <= 0;
        end else begin
            if (start_tx && ready) begin
                shift_reg <= {1'b1, data_in, 1'b0}; // start bit + data + stop bit
                bit_count <= 0;
                counter <= 0;
                transmitting <= 1;
                ready <= 0;
            end

            if (transmitting) begin
                if (counter < BIT_PERIOD - 1) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    if (bit_count < 10) begin
                        tx <= shift_reg[bit_count]; // send the next bit
                        bit_count <= bit_count + 1;
                    end else begin
                        transmitting <= 0;
                        ready <= 1; // finished transmission
                        bit_count <= 0; // reset for next transaction
                    end
                end
            end
        end
    end
endmodule