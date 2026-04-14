module spi_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire MISO,
    output reg MOSI,
    output reg SCLK,
    output reg CS
);
    reg [7:0] data_out;
    reg [7:0] data_in;
    reg [2:0] bit_count;
    reg state;

    localparam IDLE = 1'b0;
    localparam TRANSFER = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MOSI <= 1'b0;
            SCLK <= 1'b0;
            CS <= 1'b1;
            bit_count <= 3'b000;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        CS <= 1'b0; // Assert chip select
                        data_out <= 8'hA5; // Example data to send
                        bit_count <= 3'b000;
                        state <= TRANSFER;
                    end
                end
                TRANSFER: begin
                    if (bit_count < 3'b1000) begin // 8 bits transfer
                        SCLK <= ~SCLK; // Toggle clock
                        if (SCLK) begin
                            MOSI <= data_out[7]; // Send MSB first
                            data_in[7] <= MISO; // Capture MISO
                            data_out <= {data_out[6:0], 1'b0}; // Shift data out
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        CS <= 1'b1; // Deassert chip select
                        state <= IDLE; // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule