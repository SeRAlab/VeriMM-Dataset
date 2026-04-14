module top_module(
    input start,
	input clk,
    output reg done,
    output reg [2:0] cnt
    );always @(posedge clk) begin
		if(start) begin 
			done <= 1'b0;
			cnt <= 3'b110;
		end else begin
			if(cnt == 3'b000) begin 
                done <= 1'b1;
            end else begin  
                cnt <= cnt - 3'b001;
                done <= 1'b0;
            end
		end
	end


endmodule