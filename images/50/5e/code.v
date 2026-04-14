module top_module( input clk,
              input [1:0]WB_2,
              input [31:0]dm_read,aluresult,
              input [4:0] Regd,
              output[31:0]DmRead,Aluresult,
              output[4:0] RegD,
              output [1:0]WB
);reg [70:0] ME;
         always@(posedge clk) begin
                ME[70:69] <= WB_2;
                ME[68:37] <= dm_read;
                ME[36:5]  <= aluresult;
                ME[4:0]   <= Regd;
         end  
         assign WB        = ME[70:69];
         assign DmRead    = ME[68:37];
         assign Aluresult = ME[36:5];
         assign RegD      = ME[4:0];endmodule