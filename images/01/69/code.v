module pipeline_register (  
    input clk,  
    input rst,  
    input en,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] stage1_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stage1_reg <= 8'b0;  
            data_out <= 8'b0;  
        end else if (en) begin  
            stage1_reg <= data_in;  
            data_out <= stage1_reg;  
        end  
    end  
endmodule