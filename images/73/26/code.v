module loadable_counter
(
  input rst_n,
  input clk,
  input load,
  input [15:0] load_val,

  output reg [15:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
	begin
      count <= 16'd0;
    end 
	else if (load) 
	begin
      count <= load_val;
    end 
	else 
	begin
      count <= count + 1;
    end
  end

endmodule