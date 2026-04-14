module pcie_receiver(  
    input wire clk,  
    input wire valid,  
    input wire [31:0] data_in,  
    input wire [2:0] addr_in,  
    input wire output_enable,  
    output reg [31:0] data_out,  
    output reg [2:0] addr_out  
);  
    always @(posedge clk) begin  
        if (valid) begin  
            data_out <= data_in;  
            addr_out <= addr_in;  
        end  
    end  
endmodule