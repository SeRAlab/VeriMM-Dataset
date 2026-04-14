module pcie_address_decoder(  
    input [31:0] address,  
    output reg [3:0] cs  
);  
    always @(*) begin  
        case(address)  
            32'h00000000: cs = 4'b0001; // Device 0  
            32'h00000001: cs = 4'b0001; // Device 0  
            // Add more address range for Device 0, 1, 2, and 3  
            32'h00000010: cs = 4'b0010; // Device 1  
            32'h00000011: cs = 4'b0010; // Device 1  
            32'h00000020: cs = 4'b0100; // Device 2  
            32'h00000021: cs = 4'b0100; // Device 2  
            32'h00000030: cs = 4'b1000; // Device 3  
            32'h00000031: cs = 4'b1000; // Device 3  
            default: cs = 4'b0000; // No device  
        endcase  
    end  
endmodule