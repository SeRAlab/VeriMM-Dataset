module tcp_segment_type (
    input [31:0] segment,
    output [15:0] segment_type
);
    assign segment_type = (segment[2:0] == 3'b000) ? 16'd0 : // Data
                          (segment[2:0] == 3'b001) ? 16'd1 : // SYN
                          (segment[2:0] == 3'b010) ? 16'd2 : // ACK
                          (segment[2:0] == 3'b011) ? 16'd3 : // FIN
                          (segment[2:0] == 3'b100) ? 16'd4 : // RST
                          16'd0; // Default to Data
endmodule