module audio_compressor (
    input clk,
    input reset,
    input start,
    input complete,
    output reg [1:0] state // 00: IDLE, 01: COMPRESS, 10: DECOMPRESS
);
    // State encoding
    localparam IDLE = 2'b00, COMPRESS = 2'b01, DECOMPRESS = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= COMPRESS;
                    end
                end
                COMPRESS: begin
                    // Simulate compression
                    state <= DECOMPRESS; // Move to decomp when compress is done
                end
                DECOMPRESS: begin
                    if (complete) begin
                        state <= IDLE; // Return to IDLE after decompression
                    end
                end
            endcase
        end
    end
endmodule