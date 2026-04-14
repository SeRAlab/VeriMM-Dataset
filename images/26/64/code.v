module audio_sample_buffer (
    input clk,
    input reset,
    input write_enable,
    input [15:0] data_in,
    output reg [15:0] data_out,
    output reg valid
);
    reg [15:0] buffer [0:7]; // FIFO buffer of 8 samples
    reg [2:0] head; // Points to the current write location
    reg [2:0] tail; // Points to the current read location
    reg [3:0] count; // Number of samples currently in the buffer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 4'b0000;
            valid <= 1'b0;
        end else begin
            if (write_enable) begin
                buffer[head] <= data_in;
                head <= (head + 1) % 8;
                if (count < 8) begin
                    count <= count + 1;
                end
                if (count == 7) begin
                    tail <= (tail + 1) % 8; // Move tail when full
                end
            end
            
            // Output logic
            if (count > 0) begin
                data_out <= buffer[tail];
                valid <= 1'b1;
            end else begin
                valid <= 1'b0;
            end
        end
    end
endmodule