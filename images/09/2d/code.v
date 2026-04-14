module dma_controller (
    input wire clk,
    input wire reset,
    input wire start_channel1,
    input wire start_channel2,
    input wire [7:0] bytes_to_transfer1,
    input wire [7:0] bytes_to_transfer2,
    output reg done_channel1,
    output reg done_channel2
);
    reg [7:0] count1;
    reg [7:0] count2;
    reg transferring1;
    reg transferring2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count1 <= 0;
            count2 <= 0;
            transferring1 <= 0;
            transferring2 <= 0;
            done_channel1 <= 0;
            done_channel2 <= 0;
        end else begin
            if (start_channel1 && !transferring1) begin
                transferring1 <= 1;
                count1 <= bytes_to_transfer1;
                done_channel1 <= 0;
            end
            if (transferring1) begin
                if (count1 > 0) begin
                    count1 <= count1 - 1;
                end else begin
                    done_channel1 <= 1;
                    transferring1 <= 0;
                end
            end
            
            if (start_channel2 && !transferring2) begin
                transferring2 <= 1;
                count2 <= bytes_to_transfer2;
                done_channel2 <= 0;
            end
            if (transferring2) begin
                if (count2 > 0) begin
                    count2 <= count2 - 1;
                end else begin
                    done_channel2 <= 1;
                    transferring2 <= 0;
                end
            end
        end
    end
endmodule