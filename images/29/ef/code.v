module packet_filter (
    input [7:0] packet_type,
    input [7:0] allowed_type,
    output reg allow
);
    always @(*) begin
        if (packet_type == allowed_type)
            allow = 1'b1; // Allow the packet
        else
            allow = 1'b0; // Deny the packet
    end
endmodule