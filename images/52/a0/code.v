module top_module(
    input clk,
    input rst,
    input channel_out_en,
    input [31:0] channel_out_data,
    output reg channel_out_ack,
    output reg [31:0] channel_in_data,
    output reg channel_in_en,
    input channel_in_ack
);reg [1:0] state;
    parameter IDLE = 2'b00, TRANSMIT = 2'b01, RECEIVE = 2'b10;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            channel_out_ack <= 0;
            channel_in_data <= 0;
            channel_in_en <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (channel_out_en && !channel_in_ack) begin
                        state <= TRANSMIT;
                    end else if (channel_in_en) begin
                        state <= RECEIVE;
                    end
                end
                TRANSMIT: begin
                    if (channel_in_ack) begin
                        channel_out_ack <= 1;
                        state <= IDLE;
                    end
                end
                RECEIVE: begin
                    if (!channel_out_en) begin
                        channel_in_en <= 0;
                        channel_in_data <= 0;
                        channel_out_ack <= 1;
                        state <= IDLE;
                    end else if (!channel_in_en) begin
                        channel_in_en <= 1;
                        channel_in_data <= channel_out_data;
                        state <= TRANSMIT;
                    end
                end
            endcase
        end
    end

endmodule