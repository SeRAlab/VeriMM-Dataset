module top_module(
  clk, rst, clk_ena,
  
  clk_ena_job,  
  
  load,  
  
  carry,  
  
  
  dfload,  
  
  dout  
);parameter MOD_COUNT = 7;
  parameter WIDTH = 8;
  input clk, rst, clk_ena;
  input clk_ena_job;
  
  input load;
  input[WIDTH-1:0] dfload;
  output carry;
    reg carry_tmp;
  assign carry = carry_tmp;
  wire loco = load & clk_ena_job;  
  
  reg [WIDTH-1:0] count;  
  output [WIDTH-1:0] dout;  
  
  always @(posedge clk or posedge rst) begin
    if(rst)
      count <= 0;
    else if(clk_ena) begin
    if(load)  
        count <= 0;
    if(clk_ena_job)
        count <= count+1;
    if(load & clk_ena_job)  
        count <= 1;  
    end
  end
  
  always @(count) begin 
    if(count == MOD_COUNT-1)
      carry_tmp = 'b1;
    else 
      carry_tmp = 'b0;  
  end
  
  assign dout = count;endmodule