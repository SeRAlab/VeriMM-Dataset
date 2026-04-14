module ip_checksum(  
    input [15:0] data_in,  
    input valid,  
    input clk,  
    output reg [15:0] checksum_out,  
    output reg ready  
);  
    reg [31:0] sum;  
    always @(posedge clk) begin  
        if (valid) begin  
            sum <= sum + data_in;  
            ready <= 0;  
        end else begin  
            checksum_out <= ~sum[15:0] - (sum[31:16] != 0);  
            ready <= 1;  
            sum <= 0;  
        end  
    end  
endmodule