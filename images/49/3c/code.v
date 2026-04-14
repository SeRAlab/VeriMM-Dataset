module top_module(
    input clk,
    input rst,
    input rx,
    input rx_valid,
    input rx_error,
    output reg [7:0] data,
    output reg data_valid,
    output reg parity_error,
    output reg framing_error
);reg [9:0] rx_shift_reg;
reg [2:0] rx_state;
reg [3:0] error_count;

parameter IDLE = 3'b000;
parameter START = 3'b001;
parameter DATA = 3'b010;
parameter PARITY = 3'b011;
parameter STOP = 3'b100;

always @(posedge clk) begin
    if (rst) begin
        rx_shift_reg <= 10'b0;
        rx_state <= IDLE;
        error_count <= 0;
    end else begin
        case (rx_state)
            IDLE: begin
                if (rx_valid && !rx) begin
                    rx_shift_reg <= {rx_shift_reg[7:0], rx};
                    rx_state <= START;
                end
            end
            START: begin
                rx_shift_reg <= {rx_shift_reg[7:0], rx};
                rx_state <= DATA;
            end
            DATA: begin
                rx_shift_reg <= {rx_shift_reg[7:0], rx};
                rx_state <= PARITY;
            end
            PARITY: begin
                rx_shift_reg <= {rx_shift_reg[7:0], rx};
                rx_state <= STOP;
            end
            STOP: begin
                rx_shift_reg <= {rx_shift_reg[7:0], rx};
                if (rx_shift_reg[9:1] == 8'b00000001) begin
                    data <= rx_shift_reg[8:1];
                    data_valid <= 1;
                    parity_error <= (rx_shift_reg[8:1] ^ rx_shift_reg[0]) ? 1 : 0;
                    framing_error <= (rx_shift_reg[9:1] != 8'b00000001) ? 1 : 0;
                end else begin
                    error_count <= error_count + 1;
                end
                rx_state <= IDLE;
            end
        endcase
    end
end

endmodule