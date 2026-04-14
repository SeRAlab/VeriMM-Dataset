module sata_decoder(input [4:0] command, output reg [2:0] category);  
    always @(*) begin  
        case (command)  
            5'b00000: category = 3'b000; // NOP  
            5'b00001, 5'b00010: category = 3'b001; // Read commands  
            5'b00011, 5'b00100: category = 3'b010; // Write commands  
            5'b00101: category = 3'b011; // Identify Device  
            default: category = 3'b100; // Reserved commands  
        endcase  
    end  
endmodule