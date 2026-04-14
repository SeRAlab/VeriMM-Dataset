module dma_controller (
    input clk,
    input reset,
    input [7:0] data_in_ch0,
    input [7:0] data_in_ch1,
    input read_en_ch0,
    input read_en_ch1,
    input write_en,
    input channel_select,
    output reg [7:0] data_out,
    output reg transfer_complete
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            transfer_complete <= 1'b0;
        end else begin
            transfer_complete <= 1'b0; // Reset transfer_complete
            if (write_en) begin
                if (channel_select) begin
                    if (read_en_ch1) begin
                        data_out <= data_in_ch1;
                        transfer_complete <= 1'b1;
                    end
                end else begin
                    if (read_en_ch0) begin
                        data_out <= data_in_ch0;
                        transfer_complete <= 1'b1;
                    end
                end
            end
        end
    end
endmodule