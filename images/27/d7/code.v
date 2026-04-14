module tcp_segmenter (
    input [15:0] data_in,
    input segment_ctrl,
    output reg [7:0] data_out,
    output reg valid
);
    always @(posedge segment_ctrl) begin
        if (segment_ctrl) begin
            data_out <= data_in[15:8];  // First segment
            valid <= 1'b1;               // Set valid high for first segment
        end else begin
            data_out <= data_in[7:0];   // Second segment
            valid <= 1'b1;               // Set valid high for second segment
        end
    end
endmodule