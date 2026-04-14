module packet_filter (
    input [15:0] packet,
    input [15:0] filter,
    output reg allow
);
    always @(*) begin
        if (packet == filter) begin
            allow = 1'b1; // Allow the packet
        end else begin
            allow = 1'b0; // Block the packet
        end
    end
endmodule