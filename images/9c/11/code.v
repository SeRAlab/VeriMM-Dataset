module top_module(
  input clk,
  input [n-1:0] in,
  output out
);parameter n = 4; // length of input sequence
parameter seq = "1010"; // specified sequence to detect

reg [n-1:0] state;
reg out_reg;

always @(posedge clk) begin
  case(state)
    0: if(in == seq[0]) state <= 1;
       else state <= 0;
    1: if(in == seq[1]) state <= 2;
       else if(in == seq[0]) state <= 1;
       else state <= 0;
    2: if(in == seq[2]) state <= 3;
       else if(in == seq[0]) state <= 1;
       else state <= 0;
    3: if(in == seq[3]) begin
         state <= 4;
         out_reg <= 1;
       end
       else if(in == seq[0]) state <= 1;
       else state <= 0;
    4: state <= 4;
  endcase
end

assign out = out_reg;

endmodule