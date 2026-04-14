module top_module(immediate_in, sign_extend);input [13:0] immediate_in;
    output [15:0] sign_extend;	
    reg [15:0] sign_extend;



	   
    
    always @(immediate_in)
    begin
    sign_extend[13:0] = immediate_in[13:0];
    if(immediate_in[13] == 1)
       begin
          sign_extend[15] = 1'b1;
          sign_extend[14] = 1'b1;
       end
    else
       begin
          sign_extend[15] = 1'b0;
          sign_extend[14] = 1'b0;
       end
    end

endmodule