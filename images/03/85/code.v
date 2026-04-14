module packet_filter(
    input [15:0] src_addr,
    input [15:0] dest_addr,
    input [15:0] allowed_src_addr,
    input [15:0] allowed_dest_addr,
    output reg allow
);
    always @(*) begin
        if (src_addr == allowed_src_addr && dest_addr == allowed_dest_addr) 
            allow = 1'b1;
        else 
            allow = 1'b0;
    end
endmodule