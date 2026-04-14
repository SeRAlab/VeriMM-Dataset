module top_module(
	input				keyon_now,
	input				keyoff_now,
	input		[2:0]	state_in,
	input		[9:0]	eg,
	
	input		[4:0]	arate, 
	input		[4:0]	rate1, 
	input		[4:0]	rate2, 
	input		[3:0]	rrate,
	input		[3:0]	sl,   
	
	input				ssg_en,
	input		[2:0]	ssg_eg,
	
	input				ssg_inv_in,
	output reg			ssg_inv_out,

	output reg	[4:0]	base_rate,
	output reg	[2:0]	state_next,
	output reg			pg_rst
);localparam 	ATTACK = 3'b001,
			DECAY  = 3'b010,
			HOLD   = 3'b100,
			RELEASE= 3'b000; 



reg		[4:0]	sustain;

always @(*)
	if( sl == 4'd15 )
		sustain = 5'h1f; 
	else
		sustain = {1'b0, sl};

wire	ssg_en_out;
reg		ssg_en_in, ssg_pg_rst;


wire ssg_att  = ssg_eg[2];
wire ssg_alt  = ssg_eg[1];
wire ssg_hold = ssg_eg[0] & ssg_en;

reg ssg_over;


always @(*) begin
	ssg_over = ssg_en && eg[9]; 
	ssg_pg_rst = ssg_over && !( ssg_alt || ssg_hold );
	pg_rst = keyon_now | ssg_pg_rst;
end

always @(*)
	casez ( { keyoff_now, keyon_now, state_in} )
		5'b01_???: begin 
			base_rate	= arate;
			state_next	= ATTACK;
			ssg_inv_out	= ssg_att & ssg_en;
		end
		{2'b00, ATTACK}:
			if( eg==10'd0 ) begin
				base_rate	= rate1;
				state_next	= DECAY;
				ssg_inv_out	= ssg_inv_in;
			end
			else begin
				base_rate	= arate;
				state_next	= ATTACK;
				ssg_inv_out	= ssg_inv_in;
			end
		{2'b00, DECAY}: begin
			if( ssg_over ) begin
				base_rate	= ssg_hold ? 5'd0 : arate;
				state_next	= ssg_hold ? HOLD : ATTACK;
				ssg_inv_out	= ssg_en & (ssg_alt ^ ssg_inv_in);
			end
			else begin
				base_rate	=  eg[9:5] >= sustain ? rate2 : rate1; 
				state_next	= DECAY;
				ssg_inv_out = ssg_inv_in;
			end
		end
		{2'b00, HOLD}: begin
			base_rate	= 5'd0;
			state_next	= HOLD;
			ssg_inv_out	= ssg_inv_in;
		end
		default: begin 
			base_rate	= { rrate, 1'b1 };
			state_next	= RELEASE;	
			ssg_inv_out	= 1'b0; 
				
				
		end
	endcase


endmodule