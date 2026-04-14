module tcp_segment_sequencer (
    input wire clk,
    input wire reset,
    input wire [15:0] data_length,
    input wire [3:0] mss,
    output reg [3:0] num_segments
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            num_segments <= 0;
        end else begin
            if (mss > 0) begin
                num_segments <= (data_length + mss - 1) / mss; // Ceiling division
            end else begin
                num_segments <= 0; // If MSS is 0, no segments can be formed
            end
        end
    end
endmodule