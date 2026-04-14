module top_module(
    input wire rst,
    input wire clk,
    input wire pc_en,
    input wire[31:0] npc,
    
    output reg[31:0] pc
    );always @ (posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'h00000000;
        end else begin
            if (pc_en) pc <= npc;
            end         
    end
endmodule