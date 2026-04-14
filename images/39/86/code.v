module dma_controller (
    input clk,
    input rst,
    input [1:0] channel_select,
    input [7:0] data_in_0,
    input [7:0] data_in_1,
    input [7:0] data_in_2,
    input [7:0] data_in_3,
    input enable,
    output reg [7:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
        end else if (enable) begin
            case (channel_select)
                2'b00: data_out <= data_in_0;
                2'b01: data_out <= data_in_1;
                2'b10: data_out <= data_in_2;
                2'b11: data_out <= data_in_3;
                default: data_out <= 8'b0;
            endcase
        end
    end
endmodule