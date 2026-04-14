module top_module(
    input clk,
    input reset,
    input rx,
    output reg [7:0] data,
    output reg valid
);reg [3:0] state;
reg [2:0] bit_count;
reg parity;
reg [15:0] shift_reg;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter PARITY = 2'b11;

// state machine
always @(posedge clk, posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 0;
        shift_reg <= 0;
        parity <= 1;
        valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (!rx) begin
                    state <= START;
                    bit_count <= 0;
                    shift_reg <= 0;
                    parity <= 1;
                    valid <= 0;
                end
            end
            START: begin
                shift_reg <= {shift_reg[6:0], rx};
                bit_count <= bit_count + 1;
                state <= DATA;
            end
            DATA: begin
                shift_reg <= {shift_reg[6:0], rx};
                bit_count <= bit_count + 1;
                parity <= parity ^ rx;
                if (bit_count == 8) begin
                    state <= PARITY;
                    bit_count <= 0;
                end
            end
            PARITY: begin
                shift_reg <= {shift_reg[6:0], rx};
                bit_count <= bit_count + 1;
                if (parity == rx) begin
                    data <= shift_reg[7:0];
                    valid <= 1;
                end else begin
                    valid <= 0;
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule