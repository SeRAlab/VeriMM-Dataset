module dma_controller (
    input wire clk,
    input wire rst,
    input wire req_ch1,
    input wire req_ch2,
    output reg ack_ch1,
    output reg ack_ch2,
    output reg [7:0] data_out_ch1,
    output reg [7:0] data_out_ch2,
    input wire [7:0] data_in_ch1,
    input wire [7:0] data_in_ch2
);

    reg [1:0] state; // 00: idle, 01: transferring ch1, 10: transferring ch2

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            ack_ch1 <= 0;
            ack_ch2 <= 0;
            data_out_ch1 <= 8'b0;
            data_out_ch2 <= 8'b0;
        end else begin
            case (state)
                2'b00: begin // idle
                    ack_ch1 <= 0;
                    ack_ch2 <= 0;
                    if (req_ch1) begin
                        state <= 2'b01; // start transfer ch1
                    end else if (req_ch2) begin
                        state <= 2'b10; // start transfer ch2
                    end
                end
                2'b01: begin // transferring ch1
                    data_out_ch1 <= data_in_ch1;
                    ack_ch1 <= 1;
                    state <= 2'b00; // go back to idle
                end
                2'b10: begin // transferring ch2
                    data_out_ch2 <= data_in_ch2;
                    ack_ch2 <= 1;
                    state <= 2'b00; // go back to idle
                end
            endcase
        end
    end
endmodule