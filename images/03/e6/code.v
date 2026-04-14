module nat_logic(  
    input [31:0] internal_ip,  
    input [31:0] external_ip,  
    input nat_type, // 0 for static NAT, 1 for dynamic NAT  
    output reg [31:0] translated_ip  
);  
    always @(*) begin  
        if (nat_type == 0) begin  
            // Static NAT: always map to the same external IP  
            translated_ip = external_ip;  
        end else begin  
            // Dynamic NAT: map to the internal IP (for this example, just returning the internal IP)  
            translated_ip = internal_ip;  
        end  
    end  
endmodule