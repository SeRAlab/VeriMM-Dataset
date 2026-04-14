module dma_controller (
    input clk,
    input reset,
    input enable_ch1,
    input enable_ch2,
    input [7:0] data_in_ch1,
    input [7:0] data_in_ch2,
    output reg [7:0] data_out_ch1,
    output reg [7:0] data_out_ch2,
    output reg transfer_complete_ch1,
    output reg transfer_complete_ch2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_ch1 <= 8'b0;
            data_out_ch2 <= 8'b0;
            transfer_complete_ch1 <= 1'b0;
            transfer_complete_ch2 <= 1'b0;
        end else begin
            if (enable_ch1) begin
                data_out_ch1 <= data_in_ch1;
                transfer_complete_ch1 <= 1'b1;
            end else begin
                transfer_complete_ch1 <= 1'b0;
            end

            if (enable_ch2) begin
                data_out_ch2 <= data_in_ch2;
                transfer_complete_ch2 <= 1'b1;
            end else begin
                transfer_complete_ch2 <= 1'b0;
            end
        end
    end
endmodule