module dram_cell (  
    input wire we,    // Write enable  
    input wire d,     // Data input  
    output reg q      // Bitline output  
);  
    always @(posedge we or negedge we) begin  
        if (we) begin  
            q <= d;   // Store the input data when writing  
        end  
        // If we is low, maintain the current state of q  
    end  
endmodule