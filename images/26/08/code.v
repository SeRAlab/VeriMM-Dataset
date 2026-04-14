module dma_controller (
    input clk,
    input reset,
    input start_ch1,
    input start_ch2,
    input [7:0] data_ch1,
    input [7:0] data_ch2,
    output reg [7:0] destination,
    output reg done
);

reg active_channel; // 0 for channel 1, 1 for channel 2

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done <= 0;
        destination <= 8'b0;
        active_channel <= 0;
    end else begin
        if (start_ch1) begin
            active_channel <= 0; // Select channel 1
            destination <= data_ch1;
            done <= 1; // Signal that transfer is done
        end else if (start_ch2) begin
            active_channel <= 1; // Select channel 2
            destination <= data_ch2;
            done <= 1; // Signal that transfer is done
        end else begin
            done <= 0; // Reset done if no start signal
        end
    end
end

endmodule