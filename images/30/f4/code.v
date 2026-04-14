module VMU(  
    input clk,  
    input [3:0] virtual_address,  
    output reg [3:0] physical_address  
);  
    always @(posedge clk) begin  
        physical_address <= virtual_address;  
    end  
endmodule