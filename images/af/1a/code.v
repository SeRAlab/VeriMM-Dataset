module top_module(
    input clk_d,
    input rst,
    input set_en,
    input one_pulse_min,
    
    output reg [3:0] set_m0,
    output reg co_m1
    );reg [3:0] set_tmp;
    
    always@( posedge clk_d or posedge rst )
        if(rst)
            set_m0 <= 4'd0;
        else
            set_m0 <= set_tmp;
            
    always@*
        if( set_en && one_pulse_min && set_m0==4'd9)
        begin 
            set_tmp = 4'd0;
            co_m1 = 1'b1;
        end
        else if( set_en && one_pulse_min )
        begin 
           set_tmp = set_m0 + 1'b1;
           co_m1 = 1'b0;
        end
        else
        begin
            set_tmp = set_m0;
            co_m1 = 1'b0;
        end
           
    
endmodule