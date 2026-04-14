module dma_controller (
    input clk,
    input reset,
    input start_ch1,
    input start_ch2,
    output reg done_ch1,
    output reg done_ch2
);
    parameter transfer_length = 5; // Number of clock cycles for transfer
    reg [2:0] counter_ch1; // 3-bit counter for channel 1
    reg [2:0] counter_ch2; // 3-bit counter for channel 2
    reg active_ch1, active_ch2; // Flags for active transfers

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_ch1 <= 0;
            counter_ch2 <= 0;
            done_ch1 <= 0;
            done_ch2 <= 0;
            active_ch1 <= 0;
            active_ch2 <= 0;
        end else begin
            // Channel 1 transfer logic
            if (start_ch1 && !active_ch1) begin
                counter_ch1 <= 0;
                active_ch1 <= 1;
                done_ch1 <= 0;
            end

            if (active_ch1) begin
                if (counter_ch1 < transfer_length - 1) begin
                    counter_ch1 <= counter_ch1 + 1;
                end else begin
                    done_ch1 <= 1;
                    active_ch1 <= 0;
                end
            end

            // Channel 2 transfer logic
            if (start_ch2 && !active_ch2) begin
                counter_ch2 <= 0;
                active_ch2 <= 1;
                done_ch2 <= 0;
            end

            if (active_ch2) begin
                if (counter_ch2 < transfer_length - 1) begin
                    counter_ch2 <= counter_ch2 + 1;
                end else begin
                    done_ch2 <= 1;
                    active_ch2 <= 0;
                end
            end
        end
    end
endmodule