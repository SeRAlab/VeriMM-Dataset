module dma_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] addr_channel1,
    input wire [7:0] addr_channel2,
    input wire [7:0] size_channel1,
    input wire [7:0] size_channel2,
    input wire start_channel1,
    input wire start_channel2,
    output reg done_channel1,
    output reg done_channel2
);

    reg [7:0] transfer_count1;
    reg [7:0] transfer_count2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done_channel1 <= 0;
            done_channel2 <= 0;
            transfer_count1 <= 0;
            transfer_count2 <= 0;
        end else begin
            if (start_channel1 && transfer_count1 < size_channel1) begin
                transfer_count1 <= transfer_count1 + 1;
                done_channel1 <= 0;
            end else if (transfer_count1 >= size_channel1) begin
                done_channel1 <= 1;
            end

            if (start_channel2 && transfer_count2 < size_channel2) begin
                transfer_count2 <= transfer_count2 + 1;
                done_channel2 <= 0;
            end else if (transfer_count2 >= size_channel2) begin
                done_channel2 <= 1;
            end
        end
    end
endmodule