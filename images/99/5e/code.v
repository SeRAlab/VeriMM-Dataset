module top_module(
    input clk,
    input Btn_R,
    input Btn_L,
      
    output reg [2:0] RGB1 = 0,
    output reg [2:0] RGB2 = 0
    );reg [1:0]state = 0; 
    reg [1:0]nextState = 0;

    
    always @ (posedge clk)
    begin
        state <= nextState;
           
        case(state)
        0:  begin
                RGB1[0] <= 1;  
                RGB1[1] <= 0; 
                RGB1[2] <= 0; 
                RGB2[0] <= 1;
                RGB2[1] <= 0;
                RGB2[2] <= 0;
               
                if (Btn_R == 1) 
                nextState <= 1;
                if (Btn_L == 1)
                nextState <= 2;
            end
        1: begin
               RGB1[0] <= 0;  
               RGB1[1] <= 1; 
               RGB1[2] <= 0; 
               RGB2[0] <= 0;
               RGB2[1] <= 1;
               RGB2[2] <= 0;
               if (Btn_R == 1)
               nextState <= 2;
               if (Btn_L == 1)
               nextState <= 0;
           end
        2: begin
               RGB1[0] <= 0;  
               RGB1[1] <= 0; 
               RGB1[2] <= 1; 
               RGB2[0] <= 0;
               RGB2[1] <= 0; 
               RGB2[2] <= 1;  
               if (Btn_R == 1) 
               nextState <= 0;
               if (Btn_L == 1)
               nextState <= 1;
           end 
           endcase
     end   
endmodule