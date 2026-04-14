module dma_controller (
    input wire clk,
    input wire rst,
    input wire req1,
    input wire req2,
    output reg ack1,
    output reg ack2
);
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter TRANSFER1 = 2'b01;
    parameter TRANSFER2 = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ack1 <= 0;
            ack2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ack1 <= 0;
                    ack2 <= 0;
                    if (req1) begin
                        state <= TRANSFER1;
                    end else if (req2) begin
                        state <= TRANSFER2;
                    end
                end
                TRANSFER1: begin
                    ack1 <= 1;
                    if (!req1) begin
                        state <= IDLE;
                    end
                end
                TRANSFER2: begin
                    ack2 <= 1;
                    if (!req2) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule