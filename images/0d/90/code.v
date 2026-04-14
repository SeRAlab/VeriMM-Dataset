module dma_controller (
    input clk,
    input rst,
    input start_channel1,
    input start_channel2,
    input [7:0] src_addr_channel1,
    input [7:0] dest_addr_channel1,
    input [7:0] num_bytes_channel1,
    input [7:0] src_addr_channel2,
    input [7:0] dest_addr_channel2,
    input [7:0] num_bytes_channel2,
    output reg busy_channel1,
    output reg busy_channel2,
    output reg done_channel1,
    output reg done_channel2
);
    reg [7:0] byte_count_channel1;
    reg [7:0] byte_count_channel2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy_channel1 <= 0;
            busy_channel2 <= 0;
            done_channel1 <= 0;
            done_channel2 <= 0;
            byte_count_channel1 <= 0;
            byte_count_channel2 <= 0;
        end else begin
            if (start_channel1 && !busy_channel1) begin
                busy_channel1 <= 1;
                byte_count_channel1 <= num_bytes_channel1;
                done_channel1 <= 0;
            end

            if (busy_channel1) begin
                if (byte_count_channel1 > 0) begin
                    byte_count_channel1 <= byte_count_channel1 - 1;
                end else begin
                    busy_channel1 <= 0;
                    done_channel1 <= 1;
                end
            end

            if (start_channel2 && !busy_channel2) begin
                busy_channel2 <= 1;
                byte_count_channel2 <= num_bytes_channel2;
                done_channel2 <= 0;
            end

            if (busy_channel2) begin
                if (byte_count_channel2 > 0) begin
                    byte_count_channel2 <= byte_count_channel2 - 1;
                end else begin
                    busy_channel2 <= 0;
                    done_channel2 <= 1;
                end
            end
        end
    end
endmodule