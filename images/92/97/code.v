module top_module(
    input wire clk,
    input wire rst,
    input wire [5:0] stall,
    input wire branch_enable,
    input wire [31:0] branch_addr,
    output reg [31:0] pc

);always @(posedge clk) begin
    if(rst)
        pc <= 0;


    else if(branch_enable)
        pc <= branch_addr;
    else if(stall[0] == 0)
        pc <= pc + 4;
end
endmodule