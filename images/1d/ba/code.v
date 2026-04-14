module packet_filter (
    input [4:0] src_ip,
    input [1:0] protocol,
    output reg allow
);
    always @(*) begin
        if (src_ip == 5'b00001 && (protocol == 2'b00 || protocol == 2'b01)) 
            allow = 1'b1; // Allow the packet
        else 
            allow = 1'b0; // Block the packet
    end
endmodule