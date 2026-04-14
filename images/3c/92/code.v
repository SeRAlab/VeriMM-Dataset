module register_file (  
    input wire clk,  
    input wire enable,  
    input wire [2:0] sel, // 3-bit select for 8 registers  
    input wire [31:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] registers [0:7]; // 8 registers of 32 bits  
  
    always @(posedge clk) begin  
        if (enable) begin  
            registers[sel] <= data_in; // Write data to the selected register  
        end  
    end  
  
    always @(*) begin  
        data_out = registers[sel]; // Read data from the selected register  
    end  
endmodule