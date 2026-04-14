module top_module(  
        input           CLK       ,
		input           RST_n     ,
		
		output           ADC_CLK   ,
		output           ADC_PWR   ,
		input      [7:0] ADC_Din   ,
		output reg [7:0] data_out
        );reg       clock     ;
    reg       pwr       ;
    reg [50:0]counter   ;
    
    
    assign ADC_PWR      = pwr;
    assign ADC_CLK      = clock;
    
    
    always@(posedge CLK)
    begin 
        if(!RST_n)
            counter <= 0;
        else
        begin
            counter <= counter + 1'b1;
            clock   <= counter[19];
        end
    end
    
    
    always@(posedge clock)
    begin
        if(!RST_n)
            pwr <= 1'b1;
        else
            pwr <= 1'b0;
    end
    
    always@(posedge clock)
    begin
        if(!RST_n)
            data_out    <=  0;
        else if(~pwr)
            data_out    <=  ADC_Din;        
    end
endmodule