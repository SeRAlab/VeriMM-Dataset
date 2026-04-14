module dram_cell(  
    input wire clk,  
    input wire we, // write enable  
    input wire [3:0] data_in, // data input  
    output reg [3:0] data_out // data output  
);  
    reg [3:0] storage; // internal storage  
   
    always @(posedge clk) begin  
        if (we) begin  
            storage <= data_in; // Write data to storage  
        end  
        data_out <= storage; // Read data from storage  
    end  
endmodule