module pcie_endpoint_controller(  
    input clk,  
    input rst_n,  
    input [31:0] address,  
    output reg address_valid  
);  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            address_valid <= 1'b0;  
        else if (address >= 32'h00001000 && address <= 32'h0000FFFF)  
            address_valid <= 1'b1;  
        else  
            address_valid <= 1'b0;  
    end  
endmodule