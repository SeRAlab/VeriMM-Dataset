module top_module(
				input			clk_8f,
				input			rst,
				input			enb,
				output reg		clk_2f,
				output reg		clk_f	 );reg counter;

    always@(posedge clk_8f) begin
        
        if(rst) begin
            counter <= 1;
            clk_2f <= 1'b0;
            clk_f <= 1'b0;
        end

        else begin
            if(enb) begin
                if (counter < 1) begin
                    counter <= counter + 'b1;  
                end
                else begin
                    counter <= 'b0;                         
                    clk_2f <= ~clk_2f;                      
                    if(~clk_2f) clk_f <= ~clk_f;            
                end
            end
        end
    end


endmodule