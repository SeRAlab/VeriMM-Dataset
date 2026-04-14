module top_module(clk, rstd, halt);input clk, rstd, halt;
  reg[31:0] counter, counter_fin;

  always @(negedge rstd or posedge clk or posedge halt)
    if(rstd == 0) begin
      counter = 32'h00000000;
      counter_fin = 32'h00000000;
    end else if (halt == 1) begin
      
      counter_fin = counter;
    end else begin
      counter = counter + 32'h00000001;
    end

endmodule