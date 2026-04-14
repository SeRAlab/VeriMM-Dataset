module pcie_decoder (  
    input [3:0] address,  
    output reg [15:0] device_select  
);  
    always @(*) begin  
        device_select = 16'b0; // Clear the device select  
        device_select[address] = 1'b1; // Set the selected device  
    end  
endmodule