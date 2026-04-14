module VirtualMemoryUnit(  
    input wire clk,  
    input wire [19:0] virtual_addr,  
    output reg [9:0] physical_addr  
);  
    always @(posedge clk) begin  
        physical_addr <= virtual_addr[19:10];  
    end  
endmodule