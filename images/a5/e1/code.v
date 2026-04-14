module top_module(
    input clk,reset,
    output [3:0] dout
    );reg [3:0]temp;
    integer i;
    
    always@(posedge clk) begin
        if(reset)
            temp<=4'b0000;
        else begin
            temp[3]<=~temp[0];
            for(i=0;i<3;i=i+1) begin
                temp[i]<=temp[i+1];
             end
         end
    end
    
    assign dout=temp;
    
endmodule