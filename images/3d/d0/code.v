module spi_master (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sck,
    output reg ss,
    input wire miso,
    output reg done
);
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg state;

    localparam IDLE = 1'b0;
    localparam SEND = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            done <= 1'b0;
            sck <= 1'b0;
            ss <= 1'b1; // Active low
            bit_cnt <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        ss <= 1'b0; // Assert slave select
                        shift_reg <= data_in;
                        bit_cnt <= 4'b0000;
                        state <= SEND;
                        done <= 1'b0;
                    end
                end

                SEND: begin
                    if (bit_cnt < 8) begin
                        sck <= ~sck;
                        if (sck) begin
                            mosi <= shift_reg[7]; // Send MSB first
                            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
                            bit_cnt <= bit_cnt + 1;
                        end
                    end else begin
                        sck <= 1'b0;
                        ss <= 1'b1; // Deassert slave select
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule