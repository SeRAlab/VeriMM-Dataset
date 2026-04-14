module ip_checksum (  
    input [15:0] data_in,  
    input valid,  
    output reg [15:0] checksum  
);  
    reg [15:0] sum;  
    always @(*) begin  
        if (valid)  
            sum = sum + data_in;  
        checksum = ~sum;  
    end  
endmodule