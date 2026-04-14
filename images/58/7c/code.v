module top_module(
    clk_in,        
    nreset,        
    clk_out        
  );input clk_in, nreset;

  
  output clk_out;

  reg [1:0] pos_count, neg_count;


  always@(posedge clk_in)begin
    if (~nreset)begin
      pos_count<=0;
    end
    else if(pos_count == 2)begin
      pos_count <=0;
    end
    else begin
      pos_count<=pos_count+1;
    end
  end


  always@(negedge clk_in)begin
    if (~nreset)begin
      neg_count<=0;
    end
    else if(neg_count == 2)begin
      neg_count <=0;
    end
    else begin
      neg_count<=neg_count+1;
    end
  end   



  assign clk_out = ((pos_count!=2) && (neg_count!=2));

endmodule