module I2C_Master(
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire ack,
    output reg [7:0] data_out,
    output reg start,
    output reg stop
);
    reg [2:0] state;
    parameter IDLE = 3'b000, START = 3'b001, SEND = 3'b010, WAIT_ACK = 3'b011, STOP = 3'b100;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_out <= 8'b0;
            start <= 0;
            stop <= 0;
        end else begin
            case (state)
                IDLE: begin
                    start <= 0;
                    stop <= 0;
                    if (data_in) begin
                        state <= START;
                    end
                end
                START: begin
                    start <= 1;
                    data_out <= data_in;
                    state <= SEND;
                end
                SEND: begin
                    start <= 0;
                    if (ack) begin
                        state <= WAIT_ACK;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= STOP;
                    end
                end
                STOP: begin
                    stop <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule