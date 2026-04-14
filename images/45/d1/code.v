module top_module(
input wire clk,reset,
output wire hsync,vsync,video_on,p_tick,
output wire [9:0] pixel_x, pixel_y
);localparam HD = 640;
localparam HF = 48;
localparam HB = 16;
localparam HR = 96;
localparam VD = 480;
localparam VF = 10;
localparam VB = 33;
localparam VR = 2;







reg cuenta, CV;


reg[9:0] h_count_reg, h_count_next;
reg[9:0] v_count_reg, v_count_next;
reg h_sync_reg, v_sync_reg;
wire h_sync_next, v_sync_next;


wire h_end, v_end; 
wire pixel_tick;




always @(posedge clk, posedge reset)
begin
if(reset)
	begin
	
	h_count_reg <= 0;
	v_count_reg <= 0;
	h_sync_reg <= 1'b0;
	v_sync_reg <= 1'b0;
	end

else
	begin
	
	h_count_reg <= h_count_next;
	v_count_reg <= v_count_next;
	h_sync_reg <= h_sync_next;
	v_sync_reg <= v_sync_next;		
	end
end



always@(posedge clk, posedge reset)
begin

	if(reset)
	begin
	cuenta <= 0; 
	CV <= 0;
	end
	
	else
	begin
		if (cuenta == 1'b1)
			begin
			cuenta <= 0;
			CV <= ~CV;
			end
		else
			cuenta <= cuenta + 1'b1;
	end
end	

assign pixel_tick = CV;





assign h_end = (h_count_reg == (HD+HF+HB+HR-1));


assign v_end = (v_count_reg == (VD+VF+VB+VR-1));




always@(negedge pixel_tick)
begin
	
		if(h_end)
		h_count_next = 0;
	
		else
		h_count_next = h_count_reg + 1'b1;
	

end


always@(negedge pixel_tick)
begin
	
	if(h_end) 
		
		if(v_end)
		v_count_next = 0;
	
		else
		v_count_next = v_count_reg + 1'b1;
	
	else
	v_count_next = v_count_reg; 
end


assign h_sync_next = (h_count_reg >= (HD+HB)&&
							 h_count_reg <=(HD+HB+HR-1));


assign v_sync_next = (v_count_reg >= (VD+VB)&&
							 v_count_reg <=(VD+VB+VR-1));




assign video_on = (h_count_reg < HD) && (v_count_reg < VD); 
assign hsync = ~h_sync_reg;
assign vsync = ~v_sync_reg;
assign pixel_x = h_count_reg; 
assign pixel_y = v_count_reg; 
assign p_tick = pixel_tick; 

endmodule