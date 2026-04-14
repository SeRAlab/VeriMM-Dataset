module sram_cell (  
    input wire [3:0] D,  
    input wire WE,  
    input wire RE,  
    input wire CLK,  
    output reg [3:0] Q  
);  

    always @(posedge CLK) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  

    always @(negedge CLK) begin  
        if (RE) begin  
            Q <= Q; // Output the current value on Q (retains last value)  
        end  
    end  
endmodule