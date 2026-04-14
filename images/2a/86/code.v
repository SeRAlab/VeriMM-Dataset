module tcp_segment_classifier (
    input [2:0] tcp_flags,
    output reg [1:0] segment_type
);
    always @(*) begin
        case (tcp_flags)
            3'b001: segment_type = 2'b00; // SYN
            3'b010: segment_type = 2'b01; // ACK
            3'b100: segment_type = 2'b10; // DATA
            default: segment_type = 2'b11; // None
        endcase
    end
endmodule