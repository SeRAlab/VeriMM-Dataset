module tcp_checksum_validator(  
    input wire [31:0] payload,  
    input wire [15:0] checksum,  
    output reg valid  
);  
    reg [15:0] computed_checksum;  

    always @(*) begin  
        // Simple checksum calculation (sum of bytes)
        computed_checksum = (payload[7:0] + payload[15:8] + payload[23:16] + payload[31:24]) % 65536;  
        valid = (computed_checksum == checksum);  
    end  
endmodule