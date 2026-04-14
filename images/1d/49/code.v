module packet_filter (  
    input [31:0] source_ip,  
    input [15:0] dest_port,  
    output reg allowed  
);  
    always @(*) begin  
        if ((source_ip == 32'hC0A80101 || source_ip == 32'h0A000001) && (dest_port == 16'h0050 || dest_port == 16'h01BB))  
            allowed = 1;  
        else  
            allowed = 0;  
    end  
endmodule