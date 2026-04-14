module tcp_segmenter(
    input [15:0] payload,
    input [2:0] seg_type,
    output reg [15:0] seg_out,
    output reg error
);
    always @(*) begin
        error = 0; // Default no error
        case(seg_type)
            3'b000: seg_out = payload; // No segmentation
            3'b001: seg_out = {payload[15:8], payload[7:0]}; // Two 8-bit segments
            3'b010: seg_out = {payload[15:12], payload[11:8], payload[7:4], payload[3:0]}; // Four 4-bit segments
            3'b011: seg_out = {payload[15:14], payload[13:12], payload[11:10], payload[9:8], payload[7:6], payload[5:4], payload[3:2], payload[1:0]}; // Eight 2-bit segments
            3'b100: begin // Sixteen 1-bit segments
                seg_out = {payload[15], payload[14], payload[13], payload[12], payload[11], payload[10], payload[9], payload[8],
                           payload[7], payload[6], payload[5], payload[4], payload[3], payload[2], payload[1], payload[0]};
            end
            default: begin
                error = 1; // Invalid segmentation type
                seg_out = 16'b0; // Reset output
            end
        endcase
    end
endmodule