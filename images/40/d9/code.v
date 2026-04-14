module ip_checksum (  
    input [15:0] data_in,  
    input valid,  
    output reg [15:0] checksum,  
    output reg done  
);  
    reg [15:0] sum;  
    always @(*) begin  
        sum = 16'b0;  
        if (valid) begin  
            sum = sum + data_in;  
            checksum = ~sum;  
            done = 1;  
        end else begin  
            done = 0;  
        end  
    end  
endmodule