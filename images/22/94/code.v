module dma_controller(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] channel_req,
    input wire ack,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [3:0] channel_busy,
    output reg done
);
    reg [1:0] current_channel;
    reg transferring;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            channel_busy <= 4'b0000;
            done <= 1'b0;
            current_channel <= 2'b00;
            transferring <= 1'b0;
        end else if (start && !transferring) begin
            if (channel_req != 4'b0000) begin
                current_channel <= channel_req[3:0];
                channel_busy[current_channel] <= 1'b1;
                data_out <= data_in;
                transferring <= 1'b1;
            end
        end else if (transferring && ack) begin
            done <= 1'b1;
            channel_busy[current_channel] <= 1'b0;
            transferring <= 1'b0;
        end else begin
            done <= 1'b0;
        end
    end
endmodule