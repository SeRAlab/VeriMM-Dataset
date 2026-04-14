module ip_checksum (  
    input wire [15:0] data_in,  
    input wire clk,  
    input wire rst,  
    input wire calc_en,  
    output reg [15:0] checksum_out  
);  
    reg [15:0] sum;  
    reg [15:0] checksum;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            sum <= 16'b0;  
            checksum <= 16'b0;  
        end else if (calc_en) begin  
            sum <= sum + data_in;  
            checksum <= ~sum;  
        end  
    end  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            checksum_out <= 16'b0;  
        end else if (calc_en) begin  
            checksum_out <= checksum;  
        end  
    end  
endmodule