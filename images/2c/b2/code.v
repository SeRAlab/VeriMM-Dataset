module data_forwarding_unit(  
    input [4:0] src1,           // Source 1 Register  
    input [4:0] src2,           // Source 2 Register  
    input [4:0] dest1,          // Destination Register from EX stage  
    input [4:0] dest2,          // Destination Register from MEM stage  
    input [31:0] data1,         // Data from EX stage  
    input [31:0] data2,         // Data from MEM stage  
    input forward1,             // Forwarding control for src1  
    input forward2,             // Forwarding control for src2  
    output reg [31:0] out1,     // Output for src1  
    output reg [31:0] out2      // Output for src2  
);  

    always @(*) begin  
        // Forwarding logic for src1  
        if (forward1 && (src1 == dest1))  
            out1 = data1;  
        else if (forward1 && (src1 == dest2))  
            out1 = data2;  
        else  
            out1 = 32'b0;  // Original value (for simplicity, assuming 0)  

        // Forwarding logic for src2  
        if (forward2 && (src2 == dest1))  
            out2 = data1;  
        else if (forward2 && (src2 == dest2))  
            out2 = data2;  
        else  
            out2 = 32'b0;  // Original value (for simplicity, assuming 0)  
    end  
endmodule