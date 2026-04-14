module top_module(
                                    clk,     
                                    ena,     
                                    pulse,
                                    cycle    
                                   );input  clk;   
input  ena;   
output pulse; 
output cycle; 

reg  state;
wire clk_ipd;

specify
    specparam t_decode = 0,t_access = 0;
    (posedge clk => (pulse +: state)) = (t_decode,t_access);
endspecify

buf #(1) (clk_ipd,clk);
wire  pulse_opd;

buf buf_pulse  (pulse,pulse_opd);

always @(posedge clk_ipd or posedge pulse) 
begin
    if      (pulse) state <= 1'b0;
    else if (ena)   state <= 1'b1;
end

assign cycle = clk_ipd;
assign pulse_opd = state; 

endmodule