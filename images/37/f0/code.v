module tcp_segment_checker(
    input [4:0] segment_length,
    output reg is_full_segment
);
    always @(*) begin
        if (segment_length == 5'b10000) // 16 in decimal
            is_full_segment = 1'b1; // Full segment
        else
            is_full_segment = 1'b0; // Partial segment
    end
endmodule