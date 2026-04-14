module top_module(
		input  wire [7:0]   avs_s0_address,     
		input  wire         avs_s0_read,        
		output reg  [127:0] avs_s0_readdata,    
		input  wire         avs_s0_write,       
		input  wire [127:0] avs_s0_writedata,   
		output wire         avs_s0_waitrequest, 
		input  wire         clock_clk,          
		input  wire         reset_reset,        
        output reg  [7:0]   led                 
    );always @(posedge clock_clk)
    begin
        avs_s0_readdata <= {120'b0, led};
    end

    always @(posedge clock_clk)
    begin
        if(reset_reset)
            led <= 8'b0;
        else if(avs_s0_write)
            led <= avs_s0_writedata[7:0];
        else
            led <= led;
    end
endmodule