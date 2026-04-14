module dram_cell (  
    input wire [3:0] D,  
    input wire WE,  
    input wire CLK,  
    output reg [3:0] Q  
);  
    reg [3:0] storage;  
  
    always @(posedge CLK) begin  
        if (WE)  
            storage <= D;  
        else  
            Q <= storage;  
    end  
endmodule