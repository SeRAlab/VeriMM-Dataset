module top_module(
    input clk,
    input rst,
    input gameStart,
    output reg [3:0] Q,
    input en,
    output tc
    );always @(posedge clk or posedge rst)
        if(rst)
            Q<=4'd0;
        else if(en&&gameStart) begin
            Q<= Q+1;
            if(Q == 4'd9) 
                Q <= 4'd0;
    end
    
    assign tc = (Q==4'd9 && en)?1:0;
    
endmodule