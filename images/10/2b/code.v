module dma_controller (
    input clk,
    input rst,
    input req_ch1,
    input req_ch2,
    output reg ack_ch1,
    output reg ack_ch2,
    output reg status_ch1,
    output reg status_ch2
);

    reg [1:0] current_channel;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack_ch1 <= 0;
            ack_ch2 <= 0;
            status_ch1 <= 0;
            status_ch2 <= 0;
            current_channel <= 2'b00;
        end else begin
            case (current_channel)
                2'b00: begin
                    if (req_ch1) begin
                        ack_ch1 <= 1;
                        status_ch1 <= ~status_ch1; // Toggle status for channel 1
                        current_channel <= 2'b01; // Move to channel 2
                    end else if (req_ch2) begin
                        ack_ch2 <= 1;
                        status_ch2 <= ~status_ch2; // Toggle status for channel 2
                        current_channel <= 2'b10; // Move to channel 1
                    end
                end
                2'b01: begin
                    ack_ch1 <= 0; // Clear ack for channel 1
                    if (req_ch2) begin
                        ack_ch2 <= 1;
                        status_ch2 <= ~status_ch2; // Toggle status for channel 2
                        current_channel <= 2'b10; // Move to channel 1
                    end
                end
                2'b10: begin
                    ack_ch2 <= 0; // Clear ack for channel 2
                    if (req_ch1) begin
                        ack_ch1 <= 1;
                        status_ch1 <= ~status_ch1; // Toggle status for channel 1
                        current_channel <= 2'b01; // Move to channel 2
                    end
                end
            endcase
        end
    end
endmodule