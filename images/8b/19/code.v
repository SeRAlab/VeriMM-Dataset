module top_module(reset, clk, Data_i, Data_o);input reset;
    input clk;
    
    input [31:0] Data_i;
    
    output reg [31:0] Data_o;
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            Data_o <= 32'h00000000;
        end else begin
            Data_o <= Data_i;
        end
    end
endmodule