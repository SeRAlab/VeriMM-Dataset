module top_module(CLK, slowClk, RESET);input CLK; 
  input RESET;
  output reg slowClk; 

  reg[27:0] counter;



  always @ (posedge CLK or posedge RESET)
  begin
    if (RESET)
    begin
	counter <= 0;
	slowClk <= 0;
	end
    else if(counter == 50000000) begin
      counter <= 0;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule