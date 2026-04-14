module packet_filter (
    input [15:0] src_ip,
    input [15:0] dest_ip,
    output reg allow
);
    always @(*) begin
        if ((src_ip >= 16'hC0A8_0001) && (src_ip <= 16'hC0A8_00FF) && (dest_ip == 16'hC0A8_000A)) 
            allow = 1;
        else
            allow = 0;
    end
endmodule