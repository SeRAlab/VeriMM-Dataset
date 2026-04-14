module top_module(
    input clk,
    input a,
    input b,
    input e,
    output  reg [3:0] q,
    output reg [3:0] comb_q
);integer i;


    
    
    
    
    

    
    
    
    
    
    always@(posedge clk) begin
            q <= a&b ;
    end

    always@(posedge clk) begin
            q <= a|b ;
    end

    
   always@(*) begin
        for(i=0;i<4;i++) begin
            comb_q[i] = e ;
        end
   end






endmodule