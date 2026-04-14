module spi_master (
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg mosi,
    output reg sck,
    output reg done
);
    reg [2:0] bit_cnt; // to count bits sent
    reg [7:0] data_buffer; // buffer for data
    reg state; // state of the controller

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 0;
            sck <= 0;
            done <= 0;
            bit_cnt <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    done <= 0;
                    if (start) begin
                        data_buffer <= data_in;
                        bit_cnt <= 7; // start with the MSB
                        state <= 1; // move to sending state
                    end
                end
                1: begin // Sending state
                    sck <= 1; // Clock high
                    mosi <= data_buffer[bit_cnt]; // Send current bit
                    state <= 2; // Move to clock low state
                end
                2: begin // Clock low state
                    sck <= 0; // Clock low
                    if (bit_cnt == 0) begin
                        state <= 3; // Move to done state
                    end else begin
                        bit_cnt <= bit_cnt - 1; // Move to the next bit
                        state <= 1; // Back to sending state
                    end
                end
                3: begin // Done state
                    done <= 1; // Signal done
                    state <= 0; // Go back to idle
                end
            endcase
        end
    end
endmodule