module NAT_Controller(  
    input wire [31:0] src_ip,  
    input wire [31:0] dst_ip,  
    input wire nat_enable,  
    output reg [31:0] out_src_ip,  
    output reg [31:0] out_dst_ip  
);  

    parameter NAT_ADDRESS = 32'hC0A80101; // 192.168.1.1  

    always @(src_ip or dst_ip or nat_enable) begin  
        if (nat_enable) begin  
            out_src_ip = NAT_ADDRESS;  
        end else begin  
            out_src_ip = src_ip;  
        end  
        out_dst_ip = dst_ip;  
    end  
endmodule