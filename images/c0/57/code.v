module ddr3_sr4 #(
parameter PIPE_LEN=7
)(
input wire        clk,
input wire [3:0] shift_in,
output wire[3:0] shift_out
);
reg [PIPE_LEN-1:0] d0;
reg [PIPE_LEN-1:0] d1;
reg [PIPE_LEN-1:0] d2;
reg [PIPE_LEN-1:0] d3;
always @(posedge clk)
begin
  d3  <={shift_in[ 3],d3[PIPE_LEN-1:1]};
  d2  <={shift_in[ 2],d2[PIPE_LEN-1:1]};
  d1  <={shift_in[ 1],d1[PIPE_LEN-1:1]};
  d0  <={shift_in[ 0],d0[PIPE_LEN-1:1]};
end    
assign shift_out={d3[0],d2[0],d1[0],d0[0]};
endmodule