module top_module(
    clk_i,
    start_i,
    PCWrite_i,
    pc_i,
    pc_o
);input               clk_i, PCWrite_i;
input               start_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;


reg     [31:0]      pc_o;


always@(negedge clk_i or negedge start_i) begin

    if(~start_i) begin
        pc_o <= 32'b0;
    end
    else if(PCWrite_i == 1)
        pc_o <= pc_o; 
    else if(PCWrite_i == 0)  begin
        pc_o <= pc_i;
    end
    
end

endmodule