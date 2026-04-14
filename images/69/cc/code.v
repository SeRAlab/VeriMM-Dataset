module top_module(
               input            CLK,
               input            RST, 
               input            UP,
               input            DOWN,
               output reg [3:0] CODE
               );reg [3:0]                    cnt4;
   always @( posedge CLK ) begin
      if ( !RST )
        cnt4 <= 4'b0000;
      else if ( UP ) 
        cnt4 <= cnt4 + 4'b0001;
      else if ( DOWN ) 
        cnt4 <= cnt4 - 4'b0001;
   end

   
   always @* begin
      CODE = cnt4 ^ (cnt4 >> 1);
   end
   
endmodule