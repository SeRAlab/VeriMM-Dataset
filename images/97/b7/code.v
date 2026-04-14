module top_module(
    input branch, en_fetch, input [3:0] opcode,
    output reg pc_sel, pc0);always @(*) begin 
    if ((branch | (opcode != 4'b1)) & en_fetch) begin
      pc_sel = branch;
      pc0 = 1;
    end
    else begin
      pc0 = 0;
      pc_sel = 0;
    end
  end

endmodule