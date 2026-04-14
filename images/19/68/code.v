module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire stop,
    input wire channel_select, // 0 for Channel 0, 1 for Channel 1
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg transfer_done
);
    reg [7:0] data0;
    reg [7:0] data1;
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data0 <= 8'b0;
            data1 <= 8'b0;
            transferring <= 1'b0;
            transfer_done <= 1'b0;
            data_out <= 8'b0;
        end else if (start && !transferring) begin
            transferring <= 1'b1;
            transfer_done <= 1'b0;
            if (channel_select == 1'b0) begin
                data0 <= data_in;
            end else begin
                data1 <= data_in;
            end
        end else if (transferring) begin
            if (channel_select == 1'b0) begin
                data_out <= data0;
            end else begin
                data_out <= data1;
            end
            transferring <= 1'b0;
            transfer_done <= 1'b1;
        end else if (stop) begin
            transferring <= 1'b0;
            transfer_done <= 1'b0;
        end
    end
endmodule