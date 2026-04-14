module dynamic_range_compressor (
    input clk,
    input rst,
    input signed [15:0] audio_in,
    input [2:0] compression_ratio,
    output reg signed [15:0] audio_out
);
    reg signed [15:0] threshold;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            audio_out <= 16'b0;
            threshold <= 16'b0;
        end else begin
            // Set threshold based on compression_ratio
            case (compression_ratio)
                3'b000: threshold <= 16'd1000;   // 1:1
                3'b001: threshold <= 16'd500;    // 2:1
                3'b010: threshold <= 16'd200;    // 5:1
                3'b011: threshold <= 16'd100;    // 10:1
                3'b100: threshold <= 16'd50;     // 20:1
                default: threshold <= 16'd0;
            endcase
            
            // Compress audio signal
            if (audio_in > threshold) begin
                audio_out <= threshold + (audio_in - threshold) / (compression_ratio + 1);
            end else begin
                audio_out <= audio_in;
            end
        end
    end
endmodule