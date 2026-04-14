module dma_controller (
    input clk,
    input reset,
    input req_ch1,
    input req_ch2,
    output reg ack_ch1,
    output reg ack_ch2,
    input sel // 0 for channel 1, 1 for channel 2
);
    reg [1:0] state; // 00: idle, 01: ack_ch1, 10: ack_ch2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            ack_ch1 <= 0;
            ack_ch2 <= 0;
        end else begin
            case (state)
                2'b00: begin
                    ack_ch1 <= 0;
                    ack_ch2 <= 0;
                    if (req_ch1) state <= 2'b01; // channel 1 request
                    else if (req_ch2) state <= 2'b10; // channel 2 request
                end
                2'b01: begin
                    ack_ch1 <= 1; // acknowledge channel 1
                    ack_ch2 <= 0;
                    state <= 2'b00; // return to idle
                end
                2'b10: begin
                    ack_ch1 <= 0;
                    ack_ch2 <= 1; // acknowledge channel 2
                    state <= 2'b00; // return to idle
                end
            endcase
        end
    end
endmodule