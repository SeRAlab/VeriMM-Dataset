module pitch_detection(
    input clk,
    input reset,
    input [7:0] sample, // 8-bit audio sample
    input [7:0] threshold, // threshold for pitch detection
    output reg [7:0] count // count of consecutive samples above threshold
);
    reg [7:0] temp_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp_count <= 0;
            count <= 0;
        end else begin
            if (sample > threshold) begin
                temp_count <= temp_count + 1;
            end else begin
                count <= temp_count;
                temp_count <= 0;
            end
        end
    end
endmodule