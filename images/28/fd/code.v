module tcp_segmentor (
    input clk,
    input reset,
    input [127:0] data_in, // Input data block (up to 128 bits)
    input [15:0] mss,      // Maximum segment size (in bits)
    input data_valid,      // Input data valid signal
    output reg [127:0] data_out, // Output segmented data
    output reg segment_valid, // Output segment valid signal
    output reg done         // Output done signal
);
    reg [15:0] data_len; // Length of input data
    reg [15:0] offset;   // Current offset in the data
    reg [1:0] state;     // State for segmenting

    localparam IDLE = 2'b00, SEGMENT = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            offset <= 0;
            segment_valid <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_valid) begin
                        data_len <= (data_in[127:112] == 0) ? 112 :
                                    (data_in[111:96] == 0) ? 96 :
                                    (data_in[95:80] == 0) ? 80 :
                                    (data_in[79:64] == 0) ? 64 :
                                    (data_in[63:48] == 0) ? 48 :
                                    (data_in[47:32] == 0) ? 32 :
                                    (data_in[31:16] == 0) ? 16 : 16; // Example length calculation
                        offset <= 0;
                        state <= SEGMENT;
                    end
                end
                SEGMENT: begin
                    if (offset < data_len) begin
                        data_out <= data_in >> offset;
                        segment_valid <= 1;
                        offset <= offset + mss;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                    segment_valid <= 0;
                end
            endcase
        end
    end
endmodule