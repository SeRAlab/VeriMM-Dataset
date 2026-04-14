module ip_checksum (  
    input [31:0] data_in,  
    output reg [15:0] checksum  
);  
    integer i;  
    reg [15:0] sum;  
    reg [15:0] carry;  
  
    always @(*) begin  
        sum = 16'b0;  
        for (i = 0; i < 4; i = i + 1) begin  
            sum = sum + data_in[i*8 +: 8];  
            if (sum < data_in[i*8 +: 8]) begin  
                carry = 1;  
            end else begin  
                carry = 0;  
            end  
            sum = sum + carry;  
        end  
        checksum = ~sum;  
    end  
endmodule