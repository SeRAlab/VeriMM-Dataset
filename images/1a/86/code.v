module packet_filter(  
    input [31:0] src_ip,  
    input allow_packet,  
    output reg decision  
);  
    always @(*) begin  
        if (allow_packet) begin  
            decision = 1'b1; // Allow packet  
        end else begin  
            // Block packet logic (for example, block if src_ip is a certain value)  
            if (src_ip == 32'hDEADBEEF) // Example blocked IP  
                decision = 1'b0; // Block packet  
            else  
                decision = 1'b1; // Allow packet  
        end  
    end  
endmodule