module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [1:0] channel_sel,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);

    reg [1:0] current_channel;
    reg transfer_active;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 2'b00;
            transfer_active <= 1'b0;
            done <= 1'b0;
            data_out <= 8'b0;
        end else if (start) begin
            current_channel <= channel_sel;
            transfer_active <= 1'b1;
            done <= 1'b0;
        end else if (transfer_active) begin
            data_out <= data_in;
            done <= 1'b1;
            transfer_active <= 1'b0; // End transfer after one cycle
        end
    end
endmodule