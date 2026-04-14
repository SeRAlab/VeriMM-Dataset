module packet_filter(
    input [3:0] src_port,
    input [3:0] dest_port,
    output reg accept
);
    always @(*) begin
        if (src_port == 4'b0001 || src_port == 4'b0010) begin
            accept = 1'b1; // Accept packet
        end else begin
            accept = 1'b0; // Deny packet
        end
    end
endmodule