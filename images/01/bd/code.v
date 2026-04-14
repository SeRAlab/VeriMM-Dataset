module uart_tx (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);
    parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] bit_count;
    reg [9:0] shift_reg; // 1 start + 8 data + 1 stop

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            busy <= 0;
            tx <= 1; // idle state of tx is high
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 4'd8) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                busy <= 0;
                tx <= 1; // idle state
            end
            START: begin
                tx <= 0; // start bit
                busy <= 1;
                shift_reg <= {data_in, 1'b0}; // prepare data
                bit_count <= 4'd0;
            end
            DATA: begin
                tx <= shift_reg[0]; // send bit
                shift_reg <= shift_reg >> 1; // shift
                bit_count <= bit_count + 1;
            end
            STOP: begin
                tx <= 1; // stop bit
                busy <= 0;
            end
        endcase
    end
endmodule