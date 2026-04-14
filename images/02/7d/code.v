module dram_cell (  
    input wire D,  
    input wire R,  
    input wire W,  
    output reg Q  
);  
    always @(posedge W) begin  
        Q <= D;  
    end  

    always @(posedge R) begin  
        // Do nothing; Q retains its value when R is active  
    end  
endmodule