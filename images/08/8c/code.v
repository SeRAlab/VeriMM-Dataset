module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data,
    output reg data_ready
);
    parameter BAUD_RATE = 9600;
    parameter CLOCK_FREQ = 50000000;
    localparam BIT_TIME = CLOCK_FREQ / BAUD_RATE;

    reg [3:0] bit_index;
    reg [15:0] clock_count;
    reg receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 0;
            clock_count <= 0;
            data <= 0;
            data_ready <= 0;
            receiving <= 0;
        end else begin
            if (receiving) begin
                clock_count <= clock_count + 1;
                if (clock_count == BIT_TIME) begin
                    clock_count <= 0;
                    if (bit_index < 8) begin
                        data[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                    end else begin
                        data_ready <= 1;
                        receiving <= 0;
                        bit_index <= 0;
                    end
                end
            end else if (rx == 0) begin // Start bit detected
                receiving <= 1;
                clock_count <= 0;
                data_ready <= 0;
            end
        end
    end
endmodule