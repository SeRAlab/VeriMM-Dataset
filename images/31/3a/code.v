module sram_cell(  
    input [15:0] D,  
    input [3:0] A,  
    input WE,  
    output reg [15:0] Q  
);  
    reg [15:0] memory [0:15]; // 16x16-bit memory array  

    always @(posedge WE) begin  
        memory[A] <= D; // Write operation  
    end  

    always @(*) begin  
        Q = memory[A]; // Read operation  
    end  
endmodule