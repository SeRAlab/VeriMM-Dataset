module pcie_decoder(input [4:0] signal, output reg [1:0] control);  
    always @(*) begin  
        case (signal)  
            5'b00000: control = 2'b00; // No operation  
            5'b00001: control = 2'b01; // Read operation  
            5'b00010: control = 2'b10; // Write operation  
            default: control = 2'b00; // Reserved or No operation  
        endcase  
    end  
endmodule