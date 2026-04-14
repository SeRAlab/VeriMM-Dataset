module dma_controller (
    input clk,
    input reset,
    input [7:0] data_in,
    input valid,
    input channel_select, // 0 for channel 1, 1 for channel 2
    input request,
    output reg transfer_complete,
    output reg [7:0] data_out1, // Output data for channel 1
    output reg [7:0] data_out2  // Output data for channel 2
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_complete <= 0;
            data_out1 <= 0;
            data_out2 <= 0;
        end else if (request && valid) begin
            if (channel_select == 0) begin
                data_out1 <= data_in;
            end else begin
                data_out2 <= data_in;
            end
            transfer_complete <= 1;
        end else begin
            transfer_complete <= 0;
        end
    end
endmodule