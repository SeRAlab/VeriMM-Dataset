module mmu (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] virtual_address,  
    output reg [2:0] physical_address  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            physical_address <= 3'b000;  
        end else begin  
            case (virtual_address)  
                5'b00000: physical_address <= 3'b000;  
                5'b00001: physical_address <= 3'b001;  
                5'b00010: physical_address <= 3'b010;  
                5'b00011: physical_address <= 3'b011;  
                5'b00100: physical_address <= 3'b100;  
                default: physical_address <= 3'b111;  
            endcase  
        end  
    end  
endmodule