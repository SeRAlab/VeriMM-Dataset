module nat_translation(  
    input [31:0] private_ip,  
    input [31:0] public_ip,  
    output reg [31:0] translated_ip  
);  

always @(*) begin  
    // Check if the private IP is in the range of 192.168.0.0 to 192.168.255.255  
    if (private_ip >= 32'hC0A80000 && private_ip <= 32'hC0A8FFFF) begin  
        translated_ip = public_ip;  
    end else begin  
        translated_ip = private_ip; // No translation  
    end  
end  
endmodule