module spi_master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg s_clk,
    output reg cs,
    output reg done
);

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    localparam IDLE = 4'b0000,
               START = 4'b0001,
               TRANSFER = 4'b0010,
               STOP = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            mosi <= 1'b0;
            s_clk <= 1'b0;
            cs <= 1'b1;  // Chip select inactive
            done <= 1'b0;
            bit_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    cs <= 1'b1;
                    done <= 1'b0;
                    if (start) begin
                        shift_reg <= data_in;
                        bit_count <= 3'b0;
                        cs <= 1'b0;  // Assert chip select
                        state <= START;
                    end
                end

                START: begin
                    s_clk <= 1'b0;
                    state <= TRANSFER;
                end

                TRANSFER: begin
                    if (bit_count < 3'b1000) begin
                        s_clk <= ~s_clk; // Toggle clock
                        if (s_clk) begin
                            mosi <= shift_reg[7]; // Send MSB first
                            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    cs <= 1'b1; // Deassert chip select
                    done <= 1'b1; // Transmission done
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule