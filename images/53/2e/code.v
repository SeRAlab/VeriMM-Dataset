module top_module(
	enable,
	clock,
	dataa,
	datab,
	result);parameter INPUT1_WIDTH = 32;
  parameter INPUT2_WIDTH = 32;

  localparam INPUT1_WIDTH_WITH_SIGN = INPUT1_WIDTH < 32 ? INPUT1_WIDTH + 1 : INPUT1_WIDTH;
  localparam INPUT2_WIDTH_WITH_SIGN = INPUT2_WIDTH < 32 ? INPUT2_WIDTH + 1 : INPUT2_WIDTH;
    
	input	  enable;
	input	  clock;
	input	[INPUT1_WIDTH_WITH_SIGN - 1 : 0]  dataa;
	input	[INPUT2_WIDTH_WITH_SIGN - 1 : 0]  datab;

	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) output reg [31:0] result;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [INPUT1_WIDTH_WITH_SIGN - 1 : 0]  reg_dataa;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [INPUT2_WIDTH_WITH_SIGN - 1 : 0]  reg_datab;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [INPUT1_WIDTH_WITH_SIGN - 1 : 0]  reg_dataa2;
	(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [INPUT2_WIDTH_WITH_SIGN - 1 : 0]  reg_datab2;

  always@(posedge clock)
  begin
    if (enable)
    begin
      result <= reg_dataa2 * reg_datab2; 
      reg_dataa <= dataa;
      reg_datab <= datab;
      reg_dataa2 <= reg_dataa;
      reg_datab2 <= reg_datab;
    end
  end
  
endmodule