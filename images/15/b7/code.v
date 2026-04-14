module pcie_endpoint_controller(  
    input wire clk,  
    input wire reset,  
    input wire write_enable,  
    input wire [31:0] data_in,  
    output reg [31:0] data_out  
);  
    reg [31:0] data_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_reg <= 32'b0;  
        end else if (write_enable) begin  
            data_reg <= data_in;  
        end  
    end  

    always @(*) begin  
        data_out = data_reg;  
    end  
endmodule