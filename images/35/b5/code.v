module dram_cell(  
    input wire D,      // Data input  
    input wire WL,     // Word line control  
    input wire CLK,    // Clock signal  
    output reg Q       // Bit line output  
);  
    always @(posedge CLK) begin  
        if (WL) begin  
            Q <= D;      // Write data to cell  
        end  
    end  
endmodule