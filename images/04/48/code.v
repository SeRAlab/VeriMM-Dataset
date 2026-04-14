module pitch_detector(
    input clk,
    input reset,
    input [7:0] audio_sample,
    output reg [15:0] pitch_frequency
);
    reg [7:0] sample_window [0:49]; // 50 samples window
    reg [5:0] count; // Count zero crossings
    reg [5:0] index; // Current sample index
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pitch_frequency <= 0;
            count <= 0;
            index <= 0;
        end else begin
            sample_window[index] <= audio_sample;
            index <= (index + 1) % 50; // Circular buffer
            
            if (index == 0) begin // Every 50 samples
                count = 0;
                for (i = 1; i < 50; i = i + 1) begin
                    if ((sample_window[i-1] < 128 && sample_window[i] >= 128) || 
                        (sample_window[i-1] >= 128 && sample_window[i] < 128)) begin
                        count = count + 1;
                    end
                end
                pitch_frequency <= count;
            end
        end
    end
endmodule