module audio_sample_rate_converter(
    input clk,
    input reset,
    input [15:0] audio_in,
    input [1:0] scale_factor, // 00: 1x, 01: 2x, 10: 4x
    output reg [15:0] audio_out,
    output reg audio_out_valid
);
    reg [1:0] count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
            audio_out_valid <= 0;
            audio_out <= 16'b0;
        end else begin
            case (scale_factor)
                2'b00: begin // 1x
                    audio_out <= audio_in;
                    audio_out_valid <= 1;
                end
                2'b01: begin // 2x
                    if (count == 2'b00) begin
                        audio_out <= audio_in;
                        audio_out_valid <= 1;
                        count <= count + 1;
                    end else begin
                        audio_out_valid <= 0;
                        count <= count + 1;
                    end
                end
                2'b10: begin // 4x
                    if (count == 2'b00) begin
                        audio_out <= audio_in;
                        audio_out_valid <= 1;
                    end else begin
                        audio_out_valid <= 0;
                    end
                    count <= (count + 1) % 4; // Cycle through 0 to 3
                end
                default: begin
                    audio_out_valid <= 0;
                end
            endcase
        end
    end
endmodule