module dram_cell(clk, WE, RE, din, dout);  
    input clk;  
    input WE;  
    input RE;  
    input [3:0] din;  
    output reg [3:0] dout;  
    reg [3:0] storage;  

    always @(posedge clk) begin  
        if (WE) begin  
            storage <= din;  
        end  
        if (RE) begin  
            dout <= storage;  
        end  
    end  
endmodule