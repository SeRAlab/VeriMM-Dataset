module top_module(
    d_in,     
    d_sel,    
    d_out_0,  
    d_out_1,  
    d_out_2,  
    d_out_3   
);input d_in;
input [1:0] d_sel;


output d_out_0, d_out_1, d_out_2, d_out_3;


wire d_in;
wire [1:0] d_sel;
reg d_out_0, d_out_1, d_out_2, d_out_3;

always @ (d_in or d_sel) begin
  
  d_out_0 = 0;
  d_out_1 = 0;
  d_out_2 = 0;
  d_out_3 = 0;

  case (d_sel)
    0: d_out_0 = d_in;
    1: d_out_1 = d_in;
    2: d_out_2 = d_in;
    3: d_out_3 = d_in;
  endcase
end

endmodule