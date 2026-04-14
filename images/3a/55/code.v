module uart_transmitter (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    reg [3:0] state;
    reg [3:0] bit_index;
    reg [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit

    localparam IDLE = 4'd0,
               START = 4'd1,
               DATA = 4'd2,
               STOP = 4'd3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1; // idle state for tx
            busy <= 1'b0;
            state <= IDLE;
            bit_index <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 1'b0;
                    if (enable) begin
                        shift_reg <= {1'b1, data_in, 1'b0}; // start bit + data + stop bit
                        state <= START;
                        busy <= 1'b1;
                        bit_index <= 4'd0;
                    end
                end
                START: begin
                    tx <= 1'b0; // send start bit
                    state <= DATA;
                end
                DATA: begin
                    if (bit_index < 8) begin
                        tx <= shift_reg[bit_index]; // send each data bit
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    tx <= 1'b1; // send stop bit
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule