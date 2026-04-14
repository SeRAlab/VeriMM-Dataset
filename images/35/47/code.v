module tcp_segment_parser (
    input [31:0] tcp_segment,
    output reg [15:0] src_port,
    output reg [15:0] dest_port,
    output reg [31:0] seq_num,
    output reg [31:0] ack_num,
    output reg [3:0] data_offset,
    output reg [2:0] reserved,
    output reg [8:0] control_flags,
    output reg [15:0] window_size,
    output reg [15:0] checksum,
    output reg [15:0] urgent_pointer
);
    always @(*) begin
        src_port = tcp_segment[31:16];
        dest_port = tcp_segment[15:0];
        seq_num = tcp_segment[63:32];
        ack_num = tcp_segment[95:64];
        data_offset = tcp_segment[99:96];
        reserved = tcp_segment[102:100];
        control_flags = tcp_segment[111:103];
        window_size = tcp_segment[127:112];
        checksum = tcp_segment[143:128];
        urgent_pointer = tcp_segment[159:144];
    end
endmodule