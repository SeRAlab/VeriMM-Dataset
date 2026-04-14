module top_module(
    input clk,
    input rst,
    input [5:0]stall,
    input branch_en_i,
    input [31:0]branch_target_addr_i,
    output reg [31:0]pc,
    output reg ce
);always @(posedge clk) begin
    if(rst == 1'b1) begin
      ce <= 1'b0;
    end else begin
      ce <= 1'b1;
    end
end

always @(posedge clk)begin
    if(rst == 1'b1 || ce == 1'b0)begin
        pc <= 32'h80000000;
    end else begin
        if(stall[0] == 1'b0 )begin
            if(branch_en_i)begin
                pc <= branch_target_addr_i;
            end else begin
                pc <= pc + 4'h4;
            end
        end
    end
end
endmodule