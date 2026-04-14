module audio_frame_buffer(
    input clk,
    input rst,
    input [15:0] audio_in,
    input wr_en,
    input rd_en,
    output reg [15:0] audio_out,
    output reg full,
    output reg empty
);
    parameter BUFFER_SIZE = 8;
    reg [15:0] buffer [0:BUFFER_SIZE-1];
    reg [2:0] write_ptr;
    reg [2:0] read_ptr;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            // Write to the buffer
            if (wr_en && !full) begin
                buffer[write_ptr] <= audio_in;
                write_ptr <= (write_ptr + 1) % BUFFER_SIZE;
                count <= count + 1;
            end

            // Read from the buffer
            if (rd_en && !empty) begin
                audio_out <= buffer[read_ptr];
                read_ptr <= (read_ptr + 1) % BUFFER_SIZE;
                count <= count - 1;
            end

            // Update full and empty signals
            full <= (count == BUFFER_SIZE);
            empty <= (count == 0);
        end
    end
endmodule