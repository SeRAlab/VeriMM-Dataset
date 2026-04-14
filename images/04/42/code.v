module ip_checksum (  
    input [15:0] data0,  
    input [15:0] data1,  
    input [15:0] data2,  
    input [15:0] data3,  
    input [15:0] data4,  
    output reg [15:0] checksum  
);  
    wire [15:0] sum;  
    wire [16:0] total;  

    assign total = data0 + data1 + data2 + data3 + data4;  
    assign sum = total[15:0] + total[16];  // Add carry if exists  
    always @* begin  
        checksum = ~sum;  
    end  
endmodule