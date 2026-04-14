module ip_checksum(  
    input [79:0] data, // 5 x 16-bit data  
    output reg [15:0] checksum  
);  
    integer i;  
    reg [31:0] sum;  

    always @(*) begin  
        sum = 0;  
        for (i = 0; i < 5; i = i + 1) begin  
            sum = sum + data[16*i +: 16];  
        end  
        // Add carry  
        sum = (sum >> 16) + (sum & 16'hFFFF);  
        // One's complement  
        checksum = ~sum[15:0];  
    end  
endmodule