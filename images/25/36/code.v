module dram_cell (  
    input wire clk,  
    input wire we,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    reg [15:0] storage;  
   
    always @(posedge clk) begin  
        if (we)  
            storage <= data_in;  
        else  
            data_out <= storage;  
    end  
endmodule