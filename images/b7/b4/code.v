module top_module(
    input   detect,
    input   los,
    output  shutdown,
    output  tx,
    
    input   clk,
    output  o_detect,
    output  o_los,
    input   i_shutdown
);assign o_detect = ~detect;
    assign o_los = los;
    assign shutdown = i_shutdown;

    reg r_tx = 1'b0;
    reg [26:0] c;
    always @(posedge clk) begin
	     
        
        
		  
		  
        
        
        
        if (c == 49)          
            begin
                r_tx <= ~r_tx;
                c <= 0; 
            end
        else
            begin
                c <= c + 1'b1; 
            end
    end
    assign tx = r_tx;
endmodule