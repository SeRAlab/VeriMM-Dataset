module dram_4bit (  
    input wire clk,  
    input wire we,  // write enable  
    input wire re,  // read enable  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] storage;  

    always @(posedge clk) begin  
        if (we) begin  
            storage <= data_in;  
        end  
    end  

    always @(posedge clk) begin  
        if (re) begin  
            data_out <= storage;  
        end  
    end  
endmodule