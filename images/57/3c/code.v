module top_module(
    
    crc,
    
    clk, rst, en, data_in
    );input clk, rst;
    input en;
    input [7:0] data_in;
    output wire [31:0] crc;

    reg [31:0] 	  state;
    assign crc = state ^ 32'hffffffff;
    reg [31:0] 	  temp;

    reg [4:0] 	  i;
    always @(posedge clk)
      if(rst == 1'b1) begin
	  state <= 32'hffffffff;
	  
      end
      else if(en == 1) begin

	  state <= temp;
      end

    always @(*) begin
	temp = state ^ {24'b0, data_in};
	for (i=0;i<8;i=i+1)
	  if((temp & 32'b1) != 0)
	    temp = (temp >> 1) ^ 32'hedb88320;
	  else
	    temp = (temp >> 1);
    end
    
    

endmodule