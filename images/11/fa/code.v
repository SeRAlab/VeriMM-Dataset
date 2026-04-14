module spi_master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg sclk,
    output reg mosi,
    output reg done
);
    reg [2:0] state;
    reg [3:0] bit_count;

    localparam IDLE = 3'b000,
               TRANSMIT = 3'b001,
               DONE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sclk <= 0;
            mosi <= 0;
            done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= TRANSMIT;
                        bit_count <= 0;
                    end
                end
                TRANSMIT: begin
                    if (bit_count < 8) begin
                        sclk <= ~sclk; // Toggle clock
                        if (sclk) begin // On the rising edge, send one bit
                            mosi <= data_in[7 - bit_count];
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        state <= DONE; // Move to done after 8 bits
                    end
                end
                DONE: begin
                    done <= 1; // Indicate transmission is done
                    state <= IDLE; // Go back to idle
                end
            endcase
        end
    end
endmodule