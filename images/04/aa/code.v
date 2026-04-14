module pcie_packet_parser(  
    input wire clk,  
    input wire rst,  
    input wire [127:0] pcie_packet,  
    output reg [7:0] tlp_type,  
    output reg [15:0] req_id,  
    output reg [31:0] address  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            tlp_type <= 8'b0;  
            req_id <= 16'b0;  
            address <= 32'b0;  
        end else begin  
            tlp_type <= pcie_packet[127:120];  
            req_id <= pcie_packet[119:104];  
            address <= pcie_packet[103:72];  
        end  
    end  
endmodule