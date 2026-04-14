module top_module(Address, Din, Clock, Reset, WriteEnabled, Dout);input [5:0] Address; 
  input [6:0] Din; 
  input Reset; 
  input Clock, WriteEnabled; 
  output [6:0] Dout; 
  reg [6:0] Data [39:0]; 
  always@(posedge Clock or posedge Reset) 
  if (Reset == 1) begin 
  Data[0] <= "E"; 
  Data[1] <= "C"; 
  Data[2] <= "E"; 
  Data[3] <= "3"; 
  Data[4] <= "3"; 
  Data[5] <= "3"; 
  Data[6] <= " "; 
  Data[7] <= "F"; 
  Data[8] <= "a"; 
  Data[9] <= "l"; 
  Data[10] <= "l"; 
  Data[11] <= " "; 
  Data[12] <= "2"; 
  Data[13] <= "0"; 
  Data[14] <= "1"; 
  Data[15] <= "5"; 
  Data[16] <= " "; 
  Data[17] <= "D"; 
  Data[18] <= "i"; 
  Data[19] <= "g"; 
  Data[20] <= "i"; 
  Data[21] <= "t"; 
  Data[22] <= "a"; 
  Data[23] <= "l"; 
  Data[24] <= " "; 
  Data[25] <= "S"; 
  Data[26] <= "y"; 
  Data[27] <= "s"; 
  Data[28] <= "t"; 
  Data[29] <= "e"; 
  Data[30] <= "m"; 
  Data[31] <= "s"; 
  Data[32] <= "\n"; 
  Data[33] <= "\r"; 
  end 
  else if (WriteEnabled == 1) Data[Address] <= Din; 
  assign Dout = Data[Address]; 
 endmodule