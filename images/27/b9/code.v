module dram_cell (  
    input wire [3:0] D,  
    input wire WE,  
    input wire RE,  
    input wire RST,  
    output reg [3:0] Q  
);  

always @(posedge WE or posedge RST) begin  
    if (RST) begin  
        Q <= 4'b0000;  
    end else begin  
        Q <= D;  
    end  
end  

always @(posedge RE) begin  
    // Output the stored data Q when RE is high  
    // This does not affect the stored value.  
end  

endmodule