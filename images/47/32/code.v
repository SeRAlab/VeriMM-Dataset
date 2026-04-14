module top_module(
    input enable,
    input clk_in,
    input reset,
    input wire [7:0] din,
    output busy,
    output reg done,
    output reg tx
);parameter count = 8;

reg [8:0] data = 9'b111111111; // Changed to 9 bits to match the width
reg [3:0] bitpos = 0;
reg [1:0] state = 2'b00;
reg [31:0] counter = 0;

initial begin
    tx <= 1'b1;
    done = 1'b0;
end

parameter STATE_IDLE = 2'b00;
parameter STATE_START = 2'b01;
parameter STATE_DATA = 2'b10;
parameter STATE_STOP = 2'b11;

always @(posedge clk_in) begin
    if (reset) begin
        tx <= 1'b1;
        state <= STATE_IDLE;
        done <= 1'b0;
        counter <= 0;
        bitpos <= 0;
    end
    else begin
        case (state)
            STATE_IDLE: begin
                done <= 1'b0;
                tx <= 1'b1;
                if (enable) begin
                    state <= STATE_START;
                    data <= {1'b1, din}; // Properly concatenate 1'b1 for start bit
                    bitpos <= 0;
                end
            end
            STATE_START: begin
                tx <= 1'b0;
                state <= STATE_DATA;
            end
            STATE_DATA: begin
                if (bitpos < count) begin // Changed <= to < for proper handling
                    counter <= counter + 1;
                    if (counter == 5208) begin
                        tx <= data[bitpos];
                        bitpos <= bitpos + 1;
                        counter <= 0;
                        if (bitpos == count - 1) begin // Check for last bit correctly
                            state <= STATE_STOP;
                        end
                    end
                end
            end
            STATE_STOP: begin
                tx <= 1'b1;
                done <= 1'b1;
                state <= STATE_IDLE;
            end
            default: begin
                tx <= 1'b1;
                state <= STATE_IDLE;
            end
        endcase
    end
end

assign busy = (state != STATE_IDLE);

endmodule