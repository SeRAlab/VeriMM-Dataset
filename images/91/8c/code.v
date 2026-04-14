module top_module(
    output reg[6:0] out,
    input wire [15:0] in
    );always @(in) begin

        
        if((&in[13:7])== 1) out= in[13:7];

        
        else if(in[6]== 0) out= in[13:7];

        
        
        else if((in[6]==1) && ((|in[5:0])==1)) out= in[13:7]+7'b000_0001;

        
        
        else if(in[7]==0) out= in[13:7];
        
        else out= in[13:7]+7'b000_0001;
    end
endmodule