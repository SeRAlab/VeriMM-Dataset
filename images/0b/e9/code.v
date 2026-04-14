module spi_master(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg cs,
    output reg mosi,
    input miso,
    output reg [7:0] data_out,
    output reg done
);
    reg [2:0] state;
    reg [2:0] bit_count;
    parameter IDLE = 3'b000, TRANSMIT = 3'b001, RECEIVE = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            cs <= 1;
            mosi <= 0;
            data_out <= 0;
            done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        cs <= 0; // Activate chip select
                        bit_count <= 7; // Start with the MSB
                        mosi <= data_in[bit_count];
                        state <= TRANSMIT;
                    end
                end

                TRANSMIT: begin
                    if (bit_count > 0) begin
                        bit_count <= bit_count - 1;
                        mosi <= data_in[bit_count];
                    end else begin
                        state <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    data_out[bit_count] <= miso; // Read from MISO
                    if (bit_count == 0) begin
                        state <= DONE;
                    end else begin
                        bit_count <= bit_count - 1;
                    end
                end

                DONE: begin
                    cs <= 1; // Deactivate chip select
                    done <= 1; // Indicate transmission is done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule