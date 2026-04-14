module dma_controller (
    input wire clk,
    input wire reset,
    input wire request_channel_1,
    input wire request_channel_2,
    input wire [7:0] data_in_channel_1,
    input wire [7:0] data_in_channel_2,
    output reg [7:0] data_out_channel_1,
    output reg [7:0] data_out_channel_2,
    output reg grant_channel // 1 for channel 1, 2 for channel 2
);

reg current_channel; // 0 for channel 1, 1 for channel 2

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_channel <= 0;
        data_out_channel_1 <= 8'b0;
        data_out_channel_2 <= 8'b0;
        grant_channel <= 0;
    end else begin
        if (request_channel_1 && !request_channel_2) begin
            current_channel <= 0;
        end else if (!request_channel_1 && request_channel_2) begin
            current_channel <= 1;
        end else if (request_channel_1 && request_channel_2) begin
            current_channel <= ~current_channel; // Round-robin
        end

        case (current_channel)
            0: begin
                data_out_channel_1 <= data_in_channel_1;
                grant_channel <= 1;
                data_out_channel_2 <= 8'b0; // Disable channel 2 output
            end
            1: begin
                data_out_channel_2 <= data_in_channel_2;
                grant_channel <= 2;
                data_out_channel_1 <= 8'b0; // Disable channel 1 output
            end
            default: begin
                data_out_channel_1 <= 8'b0;
                data_out_channel_2 <= 8'b0;
                grant_channel <= 0;
            end
        endcase
    end
end
endmodule