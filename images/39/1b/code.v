module uart_receiver (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_ready
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000;
    localparam BIT_PERIOD = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_count;
    reg [9:0] shift_reg;
    reg [19:0] clk_div;
    reg receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            shift_reg <= 0;
            clk_div <= 0;
            data_ready <= 0;
            receiving <= 0;
        end else begin
            if (receiving) begin
                clk_div <= clk_div + 1;
                if (clk_div == BIT_PERIOD - 1) begin
                    clk_div <= 0;
                    if (bit_count < 10) begin
                        shift_reg <= {rx, shift_reg[9:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        data_out <= shift_reg[8:1]; // Extract data bits
                        data_ready <= 1; // Data is ready
                        receiving <= 0; // Stop receiving
                    end
                end
            end else if (!rx) begin // Start bit detected
                receiving <= 1;
                bit_count <= 0;
                clk_div <= 0;
            end
        end
    end
endmodule