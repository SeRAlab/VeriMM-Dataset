module top_module(
	input clk,
	input reset,
	
	input [1:0]din,
	
	output reg davail,
	output reg [3:0]dout,
	
	output reg tbm_hdr,
	output reg tbm_trl,
	output reg roc_hdr
);reg [4:0]timeout;
	wire active = timeout[4];



	reg [1:0]d0;
	reg [1:0]d1;
	reg [1:0]d2;
	reg [1:0]d3;
	reg [1:0]d4;
	reg [1:0]d5;
	
	reg  mode1; 
	reg  mode;  

	wire [2:0]id   = mode1 ? {d1, d0[1]} : {d2[0], d1};
	wire [3:0]data = mode  ? {d2[0], d1, d0[1]} : {d2, d1};

	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			{d5, d4, d3, d2, d1, d0} <= 10'h3ff;
			dout <= 0;
		end
		else
		begin
			{d5, d4, d3, d2, d1, d0} <= {d4, d3, d2, d1, d0, din};
			dout <= data;
		end
	end


	

	wire leader0 = {d5, d4, d3, d2, d1[1]} == 9'b011111111;
	wire leader1 = {d5[0], d4, d3, d2, d1} == 9'b011111111;
	reg  leader;

	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			leader <= 0;	
			mode1  <= 0;
		end
		else
		begin			
			if (active)
			begin
				if (leader0)
				begin
					leader <= 1;
					mode1  <= 0;
				end
				else if (leader1)
				begin
					leader <= 1;
					mode1  <= 1;
				end
				else
				begin
					leader <= 0;
				end
			end
		end
	end


	
	

	always @(posedge clk or posedge reset)
	begin
		if (reset)
		begin
			davail  <= 0;
			tbm_hdr <= 0;
			tbm_trl <= 0;
			roc_hdr <= 0;
			mode    <= 0;
			timeout <= 0;
		end
		else
		begin 
			if (active && leader)
			begin
				casez (id)
					3'b100: 
						begin
							tbm_hdr <= 1;
							timeout <= 4;
							mode    <= mode1;
							davail  <= 1;
						end
					3'b110: 
						begin
							tbm_trl <= 1;
							timeout <= 4;
							mode    <= mode1;
							davail  <= 1;
						end
					3'b0??: 
						begin
							roc_hdr <= 1;
							mode    <= mode1;
							davail  <= 1;
						end
						default: davail <= !davail;
				endcase
			end 
			else
			begin
					tbm_trl <= 0;
					tbm_hdr <= 0;
					roc_hdr <= 0;
					davail  <= !davail;
			end
			
			if (!active) timeout <= timeout + 5'd1;
		end 
	end 

endmodule