module dma_controller (
    input clk,
    input reset,
    input start_ch0,
    input start_ch1,
    input [15:0] src_addr_ch0,
    input [15:0] dest_addr_ch0,
    input [7:0] transfer_size_ch0,
    input [15:0] src_addr_ch1,
    input [15:0] dest_addr_ch1,
    input [7:0] transfer_size_ch1,
    output reg done_ch0,
    output reg done_ch1
);
    reg [7:0] count_ch0;
    reg [7:0] count_ch1;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_ch0 <= 0;
            count_ch1 <= 0;
            done_ch0 <= 0;
            done_ch1 <= 0;
        end else begin
            if (start_ch0 && (count_ch0 < transfer_size_ch0)) begin
                count_ch0 <= count_ch0 + 1;
            end else if (count_ch0 >= transfer_size_ch0) begin
                done_ch0 <= 1;
            end
            
            if (start_ch1 && (count_ch1 < transfer_size_ch1)) begin
                count_ch1 <= count_ch1 + 1;
            end else if (count_ch1 >= transfer_size_ch1) begin
                done_ch1 <= 1;
            end
        end
    end
endmodule