module top_module(
    input wire clk,
    input wire clr,
    output reg [4:0] h,
    output reg [5:0] m,
    output reg [5:0] s
    );reg clr1;
    always @ (posedge clk or posedge clr)
    begin
        if (clr == 1  )
         begin
            h <= 0;
            m <= 0;
            s <= 0;
         end
        else 
             begin
                if (s == 6'b111011)
                begin
                    s <= 0;
                    if (m == 6'b111011)
                    begin 
                        m <= 0;
                        if (h == 5'b10111)
                            h <= 0;
                        else h <= h + 1'b1;
                    end
                    else begin  m <= m + 1'b1;  end
                 end
                 else s <= s + 1'b1;
              end
   end  
endmodule