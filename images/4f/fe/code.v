module top_module(
                      data_in, 
                      data_out, 
                      write, 
                      clk, 
                      reset
                    );parameter WIDTH = 8; 
parameter RESET_VALUE = 0;


input   [WIDTH-1:0] data_in;
input               write;
input               clk;
input               reset;

output  [WIDTH-1:0] data_out;
reg     [WIDTH-1:0] data_out;



always @ (posedge clk or posedge reset)
begin
  if(reset)
    data_out[WIDTH-1:0] <=  RESET_VALUE;
  else if(write)
    data_out[WIDTH-1:0] <=  data_in[WIDTH-1:0];
end


endmodule