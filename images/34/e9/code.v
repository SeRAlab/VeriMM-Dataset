module uart_rx (
    input wire clk,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);

    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000; // 50 MHz clock
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_count;
    reg [9:0] shift_reg;
    reg [15:0] clk_count;
    reg receiving;

    initial begin
        data_ready = 0;
        bit_count = 0;
        shift_reg = 0;
        clk_count = 0;
        receiving = 0;
    end

    always @(posedge clk) begin
        if (!receiving) begin
            // Wait for start bit
            if (rx == 0) begin
                receiving = 1;
                clk_count = 0;
                bit_count = 0;
            end
        end else begin
            clk_count <= clk_count + 1;
            if (clk_count >= (BIT_PERIOD / 2)) begin // Sample at the middle of the bit
                clk_count <= 0;
                if (bit_count < 10) begin
                    shift_reg <= {rx, shift_reg[9:1]}; // Shift in the received bit
                    bit_count <= bit_count + 1;
                end else begin
                    data_out <= shift_reg[8:1]; // Output the data bits
                    data_ready <= 1; // Data is ready
                    receiving <= 0; // Stop receiving
                end
            end
        end
    end

    always @(posedge clk) begin
        if (data_ready) begin
            // Reset data_ready after one clock cycle
            data_ready <= 0;
        end
    end

endmodule