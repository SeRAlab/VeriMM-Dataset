module top_module(
	input wire        rst,
	input wire        clk,
	input wire [4:0]  sensor,
	output reg [2:0]  sw,
	output reg [1:0]  dira,
	output reg [1:0]  dirb
);localparam ABOUT = 0;
	localparam AIN   = 1;
	localparam BIN   = 2;
	localparam ASTOP = 3;
	localparam BSTOP = 4;
	
	reg [2:0]  state;
	wire [1:0] s12 = {sensor[0], sensor[1]};
	wire [1:0] s13 = {sensor[0], sensor[2]};
	wire [1:0] s24 = {sensor[1], sensor[3]};
	
	always @ (posedge clk) begin
		sw[2] = 0;
	end
	
	always @ (posedge clk or posedge rst) begin
		if (rst)
			state = ABOUT;
		else
			case (state)
				ABOUT:
					case (s12)
						'b00:    state = ABOUT;
						'b01:    state = BIN;
						'b10:    state = AIN;
						'b11:    state = AIN;
						default: state = ABOUT;
					endcase
					
				AIN:
					case (s24)
						'b00:    state = AIN;
						'b01:    state = ABOUT;
						'b10:    state = BSTOP;
						'b11:    state = ABOUT;
						default: state = ABOUT;
					endcase
				
				BIN:		
					case (s13)
						'b00:    state = BIN;
						'b01:    state = ABOUT;
						'b10:    state = ASTOP;
						'b11:    state = ABOUT;
						default: state = ABOUT;
					endcase
				
				ASTOP:
					if (sensor[2])
						state = AIN;
					else
						state = ASTOP;
				
				BSTOP:
					if (sensor[3])
						state = BIN;
					else
						state = BSTOP;
				
				default:
					state = ABOUT;
			endcase
	end
	
	always @ (state) begin
		case (state)
			ABOUT: begin
				sw[0] = 0;
				sw[1] = 0;
				dira = 'b01;
				dirb = 'b01;
			end
				
			AIN: begin
				sw[0] = 0;
				sw[1] = 0;
				dira = 'b01;
				dirb = 'b01;
			end
				
			BIN: begin
				sw[0] = 1;
				sw[1] = 1;
				dira = 'b01;
				dirb = 'b01;
			end
				
			ASTOP: begin
				sw[0] = 1;
				sw[1] = 1;
				dira = 'b00;
				dirb = 'b01;
			end
				
			BSTOP: begin
				sw[0] = 0;
				sw[1] = 0;
				dira = 'b01;
				dirb = 'b00;
			end
				
			default: begin
				sw[0] = 0;
				sw[1] = 0;
				dira = 'b00;
				dirb = 'b00;
			end		
		endcase
	end
	
endmodule