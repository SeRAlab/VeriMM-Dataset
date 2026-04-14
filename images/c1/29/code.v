module hssi_tx (
    clk,     
    datain,  
    areset,  
    dataout, 
    clkout   
);
parameter channel_width = 1;
input clk;
input [channel_width-1:0] datain;
input areset;
output dataout;
output clkout;
integer i;
integer fast_clk_count;
reg clk_in_last_value;
reg dataout_tmp;
reg clkout_last_value;
reg clkout_tmp;
reg [19:0] indata;
reg [19:0] regdata;
wire clk_in;
wire areset_in;
buf (clk_in, clk);
buf (areset_in, areset);
initial
begin
    i = 0;
    fast_clk_count = channel_width;
    clk_in_last_value = 0;
    dataout_tmp = 1'b0;
    clkout_last_value = 0;
    clkout_tmp = 0;
end
always @(clk_in or areset_in)
begin
    if (areset_in == 1'b1)
    begin
        dataout_tmp = 1'b0;
        clkout_tmp = 1'b0;
        fast_clk_count = channel_width;
        for (i = channel_width-1; i >= 0; i = i - 1) 
            indata[i] = 1'b0;
        for (i = channel_width-1; i >= 0; i = i - 1) 
            regdata[i] = 1'b0;
    end
    else 
    begin
        if ((clk_in === 1'b1) && (clk_in_last_value !== clk_in))
        begin
            if (fast_clk_count == channel_width)
            begin
                fast_clk_count = 0;
                clkout_tmp = !clkout_last_value;
            end
            else if (fast_clk_count == (channel_width+1)/2)
                clkout_tmp = !clkout_last_value;
            else if (fast_clk_count < channel_width)
                clkout_tmp = clkout_last_value;
            fast_clk_count = fast_clk_count + 1;
            if (fast_clk_count == 3)
            begin
                for (i = channel_width-1; i >= 0; i = i - 1)
                    regdata[i] = indata[i];
            end
            dataout_tmp = regdata[channel_width-1];
            for (i = channel_width-1; i > 0; i = i - 1)
                regdata[i] = regdata[i-1];
        end
        if ((clk_in === 1'b0) && (clk_in_last_value !== clk_in))
        begin
            if (fast_clk_count == 3) 
            begin
                indata = datain;
            end
        end
    end
    clk_in_last_value = clk_in;
    clkout_last_value = clkout_tmp;
end
and (dataout, dataout_tmp,  1'b1);
and (clkout, clkout_tmp,  1'b1);
endmodule