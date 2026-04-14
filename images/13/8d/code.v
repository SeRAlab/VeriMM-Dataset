module pcie_controller(  
    input wire clk,  
    input wire rst,  
    input wire valid,  
    input wire [31:0] data_in,  
    output reg ready,  
    output reg [31:0] data_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ready <= 1'b0;  
            data_out <= 32'b0;  
        end else begin  
            if (valid) begin  
                data_out <= data_in;  
                ready <= 1'b1;  
            end else begin  
                ready <= 1'b0;  
            end  
        end  
    end  
endmodule