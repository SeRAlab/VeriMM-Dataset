module jpeg_compressor (
    input clk,
    input reset,
    input start,
    input [63:0] pixel_block, // 8x8 block of pixels
    output reg [15:0] compressed_output, // Compressed output
    output reg ready // Indicates when the output is valid
);
    reg [3:0] state;
    reg [15:0] sum;
    
    localparam IDLE = 4'b0000,
               PROCESS = 4'b0001,
               DONE = 4'b0010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            compressed_output <= 0;
            ready <= 0;
            sum <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        sum <= 0; // Reset sum
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    // Sum the pixel values
                    sum <= sum + pixel_block[7:0] +
                             pixel_block[15:8] +
                             pixel_block[23:16] +
                             pixel_block[31:24] +
                             pixel_block[39:32] +
                             pixel_block[47:40] +
                             pixel_block[55:48] +
                             pixel_block[63:56];
                    compressed_output <= sum; // Assign sum to output
                    state <= DONE;
                end
                DONE: begin
                    ready <= 1; // Indicate output is ready
                    state <= IDLE; // Go back to IDLE after processing
                end
            endcase
        end
    end
endmodule