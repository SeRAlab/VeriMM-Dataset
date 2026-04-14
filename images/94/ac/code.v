module top_module(
    Q  ,
    CLK,
    D  ,
    SCD,
    SCE
);output Q  ;
    input  CLK;
    input  D  ;
    input  SCD;
    input  SCE;


reg q_reg;
wire mux_out;
assign mux_out = (SCE == 1'b1)? SCD : D;

always @ ( posedge CLK)
       begin
	     q_reg <= mux_out;
       end
 
assign Q = q_reg;

endmodule