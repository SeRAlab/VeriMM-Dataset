module top_module(
    input clk,
    input rst,
    input start,
    input stop,
    output clk_div,
    output clkdiv

    );reg [27:0] counter;
reg [27:0] cter;

    always @ (posedge clk, posedge rst, posedge(stop))
    begin        
    
        if(rst==1)
        begin
            counter=0;
            cter <= cter+1;
        end
        else if(stop == 1)
        begin
            cter <= cter+1;
        end
        else
        begin
            counter <= counter + 1;
            cter <= cter+1;
        end
        
    end
    

assign clk_div = counter[15];

assign clkdiv = cter[10];
    
endmodule