module pcie_decoder (  
    input wire clk,  
    input wire [7:0] pcie_data,  
    input wire [1:0] pcie_ctl,  
    output reg [7:0] data_out  
);  
    always @(*) begin  
        case (pcie_ctl)  
            2'b00: data_out = 8'b00000000;  
            2'b01: data_out = pcie_data;  
            default: data_out = data_out;  
        endcase  
    end  
endmodule