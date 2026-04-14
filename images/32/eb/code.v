module dram_cell(  
    input wire [3:0] D,   // Data input  
    input wire WE,       // Write enable  
    input wire RE,       // Read enable  
    output reg [3:0] Q   // Data output  
);  
    reg [3:0] storage;    // Internal storage for the 4-bit data  

    always @(*) begin  
        if (WE) begin  
            storage = D;     // Store the data when write enable is high  
        end  
    end  

    always @(RE or storage) begin  
        if (RE) begin  
            Q = storage;     // Output the stored data when read enable is high  
        end  
    end  
endmodule