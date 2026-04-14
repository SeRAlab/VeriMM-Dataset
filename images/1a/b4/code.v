module tcp_segmentation (
    input [15:0] data_in,
    input [1:0] seg_type,
    output reg [15:0] seg_data,
    output reg [1:0] num_packets
);
    always @(*) begin
        case (seg_type)
            2'b00: begin // No segmentation
                seg_data = data_in;
                num_packets = 2'b01;
            end
            2'b01: begin // Segment into 2 packets
                seg_data = {data_in[15:8], data_in[7:0]}; // Just a representation
                num_packets = 2'b10;
            end
            2'b10: begin // Segment into 4 packets
                seg_data = {data_in[15:12], data_in[11:8], data_in[7:4], data_in[3:0]};
                num_packets = 2'b11;
            end
            2'b11: begin // Segment into 8 packets
                seg_data = {data_in[15:14], data_in[13:12], data_in[11:10], data_in[9:8], data_in[7:6], data_in[5:4], data_in[3:2], data_in[1:0]};
                num_packets = 2'b00;
            end
            default: begin
                seg_data = 16'b0;
                num_packets = 2'b00;
            end
        endcase
    end
endmodule