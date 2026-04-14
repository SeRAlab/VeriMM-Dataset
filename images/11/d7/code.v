module ip_checksum(  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire [15:0] data_in,  
    output reg [15:0] checksum  
);  
    reg [31:0] sum;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sum <= 0;  
            checksum <= 0;  
        end else if (enable) begin  
            sum <= sum + data_in;  
            checksum <= ~sum[15:0];  
        end  
    end  
endmodule