module uart_receiver (
    input clk,
    input reset,
    input rx,
    output reg [7:0] data,
    output reg data_ready
);
    parameter IDLE = 3'b000, START = 3'b001, DATA = 3'b010, STOP = 3'b011, OUTPUT = 3'b100;
    reg [2:0] state, next_state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_ready <= 0;
            shift_reg <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (!rx) // Start bit detected
                    next_state = START;
                else
                    next_state = IDLE;
            end
            START: begin
                next_state = DATA;
            end
            DATA: begin
                if (bit_count < 8) begin
                    next_state = DATA;
                end else begin
                    next_state = STOP;
                end
            end
            STOP: begin
                next_state = OUTPUT;
            end
            OUTPUT: begin
                data_ready = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (state == DATA) begin
            shift_reg <= {rx, shift_reg[7:1]};
            bit_count <= bit_count + 1;
        end
        if (state == OUTPUT) begin
            data <= shift_reg;
            data_ready <= 0;
            bit_count <= 0;
        end
    end
endmodule