module top_module(
    input               sys_clk  ,  
    input               sys_rst_n,  
	 
    output  reg  [3:0]  led         
);reg [23:0] counter;





                                                                                                                                                                                                                         

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        counter <= 1'b0;
    else if (counter < 24'd10000000)
        counter <= counter + 1'b1;
    else
        counter <= 24'd0;
end


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        led <= 4'b0001;
    else if(counter == 24'd10000000)
		  led <= {led[2:0], led[3]};
    else
        led <= led;
end

endmodule