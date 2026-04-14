module top_module(ledIn, ledGreen, ledRed);input [3:0] ledIn;
  output ledGreen, ledRed;
  reg ledGreen, ledRed;

  always @ (ledIn)
  begin
    if(ledIn == 4'b1111)
      begin
	ledGreen  = 1;
	ledRed = 0;
      end
    else
      begin
	ledGreen  = 0;
	ledRed = 1;
      end
  end

endmodule