module oc_fifo_basic( 
have, take_do, need, 
rst_i, clk_i, take, give, give_di
);
parameter AW=3;    
parameter DW=8;    
input            rst_i;
input            clk_i;
output           have;
input            take;
output [DW-1:0]  take_do;
output           need;
input            give;
input  [DW-1:0]  give_di;
reg  [AW  :0]    rp;
reg  [AW  :0]    wp;
wire [AW  :0]    rp_add1 = rp + 1'b1;
wire [AW  :0]    wp_add1 = wp + 1'b1;
reg              full;
reg              emty;
wire             have = ~emty;
wire             need = ~full;
reg  [DW-1:0]    mem [0:(1<<AW)-1];
wire [DW-1:0]    take_do = {DW{have}} & mem[ rp[AW-1:0] ]; 
always @( posedge clk_i )
        if( give & ~full ) mem[ wp[AW-1:0] ] <= give_di;   
always @( posedge clk_i or posedge rst_i )
if( rst_i )
begin
      wp    <= {AW+1{1'b0}};
      rp    <= {AW+1{1'b0}};
      emty  <= 1'b1;
      full  <= 1'b0;
end
else
begin
     if( give & ~full ) wp <= wp_add1; 
     if( take & ~emty ) rp <= rp_add1; 
     casex( { give,take, full,emty } )
     4'b10_0X: begin  
               full  <= ( wp_add1[AW-1:0] == rp[AW-1:0] ) & ( wp_add1[AW] != rp[AW] );
               emty  <= 1'b0;
               end
     4'b01_X0: begin  
               full  <= 1'b0;
               emty  <= ( rp_add1 == wp );
               end
     4'b11_10: full  <= 1'b0; 
     4'b11_01: emty  <= 1'b0; 
     default: ;
     endcase
end
endmodule