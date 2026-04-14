module audio_sample_buffer (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire [7:0] sample_in,
    output reg [7:0] sample_out
);
    reg [7:0] buffer [0:4]; // buffer to hold 5 samples
    reg [2:0] write_ptr; // pointer for writing samples
    reg [2:0] read_ptr; // pointer for reading samples
    reg [2:0] count; // number of samples in the buffer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            sample_out <= 8'b0;
        end else begin
            if (wr_en && count < 5) begin
                buffer[write_ptr] <= sample_in;
                write_ptr <= (write_ptr + 1) % 5;
                count <= count + 1;
            end
            if (count > 0) begin
                sample_out <= buffer[read_ptr];
                read_ptr <= (read_ptr + 1) % 5;
                count <= count - 1;
            end
        end
    end
endmodule