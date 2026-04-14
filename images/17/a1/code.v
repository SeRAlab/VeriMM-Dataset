module packet_filter (
    input [3:0] packet_type,
    output reg allowed
);
    always @(*) begin
        case (packet_type)
            4'b0001: allowed = 1'b1; // Allowed
            4'b0010: allowed = 1'b1; // Allowed
            4'b0011: allowed = 1'b1; // Allowed
            default: allowed = 1'b0; // Denied
        endcase
    end
endmodule