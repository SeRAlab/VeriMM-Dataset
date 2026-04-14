module top_module( input clk, 
              input [1:0]WB,
              input [2:0]M,
              input[31:0] result,read_2,
              input [4:0] Regd,             
              output[31:0] Result,Read_2,
              
              
              output [4:0]RegD,
              output [1:0] WB_o,
              output [2:0] M_o
   );reg [106:0] EX;
            always@(posedge clk) begin
                 EX[106:105] <= WB;
                 EX[104:102] <= M;
                
                
                 EX[68:37]   <= result;
                 EX[36:5]    <= read_2;
                 EX[4:0]     <= Regd;
            end
            assign WB_o   = EX[106:105];
            assign M_o    = EX[104:102];
           
           
            assign Result = EX[68:37];
            assign Read_2 = EX[36:5];
            assign RegD   = EX[4:0];endmodule