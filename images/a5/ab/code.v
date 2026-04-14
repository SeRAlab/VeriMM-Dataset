module top_module(
    input clk,
    input rst,
    input [3:0] data_in,
    output [3:0] data_out
    );reg [3:0] data_reg;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_reg <= 4'd0;
        end
        else begin
            data_reg <= data_in;
        end
    end
    
    assign data_out = data_reg;
    
endmodule