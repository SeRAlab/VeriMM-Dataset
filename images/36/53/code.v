module i2c_master(
    input wire clk,
    input wire start,
    input wire stop,
    output reg scl,
    output reg start_signal,
    output reg stop_signal
);
    reg [3:0] state;
    parameter IDLE = 4'b0000, START = 4'b0001, SCL_HIGH = 4'b0010, SCL_LOW = 4'b0011, STOP = 4'b0100;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                start_signal <= 0;
                stop_signal <= 0;
                if (start) begin
                    state <= START;
                end
            end
            START: begin
                start_signal <= 1;
                state <= SCL_HIGH;
            end
            SCL_HIGH: begin
                scl <= 1;
                state <= SCL_LOW;
            end
            SCL_LOW: begin
                scl <= 0;
                state <= STOP;
            end
            STOP: begin
                stop_signal <= 1;
                state <= IDLE;
            end
        endcase
    end
endmodule