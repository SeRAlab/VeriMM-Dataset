module packet_filter (  
    input [15:0] packet_header,  
    input [15:0] allowlist_0,  
    input [15:0] allowlist_1,  
    input [15:0] allowlist_2,  
    input [15:0] allowlist_3,  
    output reg allow  
);  
    always @(*) begin  
        if (packet_header == allowlist_0 ||  
            packet_header == allowlist_1 ||  
            packet_header == allowlist_2 ||  
            packet_header == allowlist_3) begin  
            allow = 1;  
        end else begin  
            allow = 0;  
        end  
    end  
endmodule