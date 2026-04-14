module top_module(
    input clk,
    input [6:0] addr_i,
    input [6:0] addr_o,
    input [15:0] data_i,
    output reg [15:0] data_o
    );reg [15:0] reg_array [127:0];
    
    always @(negedge clk) begin
        reg_array[addr_i] <= data_i;
        data_o <= reg_array[addr_o];
    end
    
endmodule