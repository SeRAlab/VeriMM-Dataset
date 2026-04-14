module NVMe_Controller(  
    input wire clk,  
    input wire reset,  
    input wire wr_en,  
    input wire [3:0] cmd_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 4'b0000;  
        end else if (wr_en) begin  
            data_out <= cmd_in;  
        end  
    end  
endmodule