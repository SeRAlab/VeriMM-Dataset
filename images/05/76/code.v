module pcie_endpoint_controller(  
    input wire clk,  
    input wire enable,  
    input wire [31:0] address,  
    input wire [31:0] data_in,  
    output reg valid,  
    output reg ready,  
    output reg [31:0] data_out  
);  

    always @(posedge clk) begin  
        if (enable) begin  
            valid <= 1;  
            ready <= 1;  
            data_out <= data_in;  
        end else begin  
            valid <= 0;  
            ready <= 0;  
        end  
    end  
endmodule