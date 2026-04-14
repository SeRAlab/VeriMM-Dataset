module spi_controller (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg MOSI,
    input MISO,
    output reg SCLK,
    output reg CS
);
    reg [2:0] state; // 0: idle, 1: start, 2: transmit, 3: receive, 4: done
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            MOSI <= 0;
            SCLK <= 0;
            CS <= 1; // Chip select inactive
            bit_count <= 0;
            shift_reg <= 0;
        end else begin
            case (state)
                0: begin // idle
                    CS <= 1;
                    if (start) begin
                        CS <= 0; // Activate chip select
                        shift_reg <= data_in;
                        bit_count <= 0;
                        state <= 1; // go to start state
                    end
                end
                1: begin // start
                    SCLK <= 0;
                    state <= 2; // go to transmit state
                end
                2: begin // transmit
                    if (bit_count < 8) begin
                        MOSI <= shift_reg[7]; // Send the MSB first
                        shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                        SCLK <= 1; // Clock high
                        state <= 3; // go to receive state
                    end else begin
                        state <= 4; // go to done state
                    end
                end
                3: begin // receive
                    SCLK <= 0; // Clock low
                    if (bit_count < 8) begin
                        // Receiving data from MISO
                        // Here you would normally sample MISO, but for simplicity we assume it's connected correctly
                        bit_count <= bit_count + 1;
                        state <= 2; // back to transmit
                    end else begin
                        state <= 4; // go to done
                    end
                end
                4: begin // done
                    CS <= 1; // Deactivate chip select
                    state <= 0; // back to idle
                end
            endcase
        end
    end
endmodule