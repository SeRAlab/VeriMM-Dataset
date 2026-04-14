module audio_frame_buffer (
    input wire clk,
    input wire reset,
    input wire [15:0] audio_in,
    input wire write,
    input wire read,
    output reg [15:0] audio_out
);
    reg [15:0] buffer [0:3]; // Buffer for 4 audio frames
    reg [1:0] write_ptr;     // Write pointer
    reg [1:0] read_ptr;      // Read pointer
    reg [2:0] count;         // Count of stored frames

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            audio_out <= 16'b0;
        end else begin
            if (write && count < 4) begin
                buffer[write_ptr] <= audio_in; // Store audio frame
                write_ptr <= write_ptr + 1;
                count <= count + 1;
            end
            if (read && count > 0) begin
                audio_out <= buffer[read_ptr]; // Output oldest audio frame
                read_ptr <= read_ptr + 1;
                count <= count - 1;
            end
        end
    end
endmodule