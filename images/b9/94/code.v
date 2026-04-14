module top_module(we, addr, datain, dataout, clk);input we; 
    input[1:0] addr; 
    input[31:0] datain; 
    output[31:0] dataout; 
    input clk; 

    reg[1:0] raddr; 
    reg[31:0] mem_block1; 
    reg[31:0] mem_block2; 

    assign dataout = (raddr == 2'b0) ? mem_block1 : mem_block2 ;

    always @(posedge clk)
    begin
       raddr <= addr ; 
       if (we == 1'b1)
       begin
          if (raddr == 2'b0)
            mem_block1 <= datain ; 
          else
            mem_block2 <= datain ; 
       end  
    end 
 endmodule