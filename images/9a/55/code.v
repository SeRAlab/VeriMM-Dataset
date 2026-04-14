module top_module(input [15:0] hex,
	output reg [15:0] dec);reg [3:0] Thous;
       reg [3:0] Hund;
       reg [3:0] Tens;
       reg [3:0] Ones;
       integer i;
       
       always@(hex) begin
          Thous = 4'd0;
          Hund = 4'd0;
          Tens = 4'b0;
          Ones = 4'b0;
          
          for(i=11; i>=0; i=i-1) 
          begin
               if(Thous >=5)
                 Thous = Thous+3;
               if(Hund >=5)
                 Hund = Hund+3;
               if(Tens >=5)
                 Tens = Tens+3;
               if(Ones >=5)
                 Ones = Ones+3;
   
               Thous = Thous << 1;
               Thous[0] = Hund[3];
   
               Hund = Hund << 1;
               Hund[0] = Tens[3];
   
               Tens = Tens << 1;
               Tens[0] = Ones[3];
   
               Ones = Ones << 1;
               Ones[0] = hex[i];
          end
          dec[15:0] = {Thous, Hund, Tens, Ones};
       end

	
endmodule