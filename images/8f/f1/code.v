module top_module(
    input [255:0] A_new,
    input clk,
    output reg exit_flag
    );always@(*)
    begin
    
        if( (A_new[143:128] == 16'b0000000000000000) | (A_new[143:128] == 16'hffff) ) begin
            if( (A_new[207:192]  == 16'b0000000000000000) | (A_new[207:192] == 16'hffff) ) begin
                if( (A_new[223:208]  == 16'b0000000000000000) | (A_new[223:208] == 16'hffff)  ) begin
                    exit_flag = 1;
                end
                else exit_flag = 0;
            end
            else exit_flag = 0;
        end
        else exit_flag = 0;
    
    end
   
endmodule