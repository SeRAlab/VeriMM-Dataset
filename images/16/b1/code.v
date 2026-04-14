module packet_filter (
    input [4:0] src_ip,
    input control,
    output reg accept
);
    always @(*) begin
        if (control) begin
            case (src_ip)
                5'b00001: accept = 1; // Accept IP 1
                5'b00010: accept = 1; // Accept IP 2
                5'b00011: accept = 1; // Accept IP 3
                default: accept = 0;   // Block all others
            endcase
        end else begin
            accept = 1; // Accept all if control is 0
        end
    end
endmodule