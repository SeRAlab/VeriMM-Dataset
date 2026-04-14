module top_module(
    input clk,
    output fout,
    input rst_n
    );reg [26:0]cnt,cnt_tmp;
    
    
    reg clk_tmp,s_cnt,s_cnt_tmp;    
    
    
    always @(cnt)
        if(cnt == 49999999) cnt_tmp <= 0;
        else cnt_tmp <= cnt + 1;
    
    always @(cnt)
        if(cnt == 49999999) clk_tmp <= 1;
        else clk_tmp <= 0;
        
    
    always @(s_cnt)
        s_cnt_tmp <= ~s_cnt ;  
        
    assign fout = s_cnt;
       
    
    always @(posedge clk_tmp or negedge rst_n)
        if (~rst_n) s_cnt <= 0;
        else s_cnt <= s_cnt_tmp;                    
    
    always @(posedge clk or negedge rst_n)
        if (~rst_n) cnt <= 27'b0;
        else cnt <= cnt_tmp;
        
endmodule