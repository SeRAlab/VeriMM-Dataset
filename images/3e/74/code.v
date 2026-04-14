module pitch_detector (
    input wire clk,
    input wire audio_signal,
    output reg pitch_in_range
);
    // Parameters for pitch detection
    parameter THRESHOLD_LOW = 200; // Example threshold values
    parameter THRESHOLD_HIGH = 300;

    reg [9:0] count; // Count cycles for frequency detection
    
    always @(posedge clk) begin
        if (audio_signal == 1'b1) begin
            count <= count + 1;
        end else begin
            if (count >= THRESHOLD_LOW && count <= THRESHOLD_HIGH) begin
                pitch_in_range <= 1'b1;
            end else begin
                pitch_in_range <= 1'b0;
            end
            count <= 0; // Reset count after processing
        end
    end
endmodule