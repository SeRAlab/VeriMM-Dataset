module flash_memory_cell (  
    input wire D,       // Data input  
    input wire W,       // Write control  
    input wire R,       // Read control  
    input wire E,       // Erase control  
    output reg Q        // Output data  
);  

always @(posedge W or posedge E) begin  
    if (E) begin  
        Q <= 1'b0;    // Erase operation  
    end else if (W) begin  
        Q <= D;       // Write operation  
    end  
end  

endmodule