module top_module(clk, rst, hsync, vsync, video_on, p_tick, pixel_x, pixel_y);input clk, rst;
output hsync, vsync, video_on, p_tick;
output [9:0] pixel_x, pixel_y;
	


parameter HD = 640; 
parameter HF = 48; 
parameter HB = 16; 
parameter HR = 96; 
parameter VD = 480; 
parameter VF = 10; 
parameter VB = 33; 
parameter VR = 2; 


reg mod2;
wire mod2Next;


reg [9:0] h_count, h_countNext;
reg [9:0] v_count, v_countNext;

reg v_sync, h_sync;
wire v_syncNext, h_syncNext;
wire h_end, v_end, pixel_tick;

always @(posedge clk) begin
		mod2 <= #1 mod2Next;
		v_count <= #1 v_countNext;
		h_count <= #1 h_countNext;
		v_sync <= #1 v_syncNext;
		h_sync <= #1 h_syncNext;
end


assign mod2Next = rst ? 0 : ~mod2;
assign pixel_tick = mod2;



assign h_end = (h_count == (HD+HF+HB+HR-1));


assign v_end = (v_count == (VD+VF+VB+VR-1));


always @(*) begin
	h_countNext = h_count;
	if(rst)
		h_countNext = 0;
	else if(pixel_tick) 
		if(h_end)
			h_countNext = 0;
		else
			h_countNext = h_count + 1;
end


always @(*) begin
	v_countNext = v_count;
	if(rst)
		v_countNext = 0;
	else if(pixel_tick & h_end)
		if(v_end)
			v_countNext = 0;
		else
			v_countNext = v_count + 1;
end



assign h_syncNext = rst ? 0 : (h_count >= (HD+HB) && h_count <= (HD+HB+HR-1));


assign v_syncNext = rst ? 0 : (v_count >= (VD+VB) && v_count <= (VD+VB+VR-1));


assign video_on = (h_count < HD) && (v_count < VD);


assign hsync = h_sync;
assign vsync = v_sync;
assign p_tick = mod2;
assign pixel_x = h_count;
assign pixel_y = v_count;

endmodule