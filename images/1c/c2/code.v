module dma_controller (
    input clk,
    input reset,
    input req_channel1,
    input req_channel2,
    output reg ack_channel1,
    output reg ack_channel2,
    output reg [7:0] data_out1,
    output reg [7:0] data_out2,
    input [7:0] data_in1,
    input [7:0] data_in2
);

    reg [1:0] state;
    localparam IDLE = 2'b00, TRANSFER1 = 2'b01, TRANSFER2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ack_channel1 <= 0;
            ack_channel2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ack_channel1 <= 0;
                    ack_channel2 <= 0;
                    if (req_channel1) begin
                        state <= TRANSFER1;
                    end else if (req_channel2) begin
                        state <= TRANSFER2;
                    end
                end
                TRANSFER1: begin
                    data_out1 <= data_in1;
                    ack_channel1 <= 1;
                    state <= IDLE;
                end
                TRANSFER2: begin
                    data_out2 <= data_in2;
                    ack_channel2 <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule