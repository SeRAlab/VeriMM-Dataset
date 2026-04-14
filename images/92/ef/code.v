module top_module(clk, Baud1Tick, TxD_start, TxD_data, TxD, TxD_busy);input 			 clk;
input 			 TxD_start;
input     		 Baud1Tick;					 // Desired baud rate
input      [7:0] TxD_data;
output 			 TxD;
output 			 TxD_busy;

// Transmitter state machine
parameter RegisterInputData = 1;	// in RegisterInputData mode, the input doesn't have to stay valid while the character is been transmitted
reg [3:0] state;
wire  TxD_ready = (state==0);
wire  TxD_busy  = ~TxD_ready;
wire  BaudTick  = TxD_busy ? Baud1Tick : 1'b0;

reg [7:0] TxD_dataReg;
always @(posedge clk) if(TxD_ready & TxD_start) TxD_dataReg <= TxD_data;
wire [7:0] TxD_dataD = RegisterInputData ? TxD_dataReg : TxD_data;

always @(posedge clk)
case(state)
	4'b0000: if(TxD_start) state <= 4'b0001;
	4'b0001: if(BaudTick) state <= 4'b0100;
	4'b0100: if(BaudTick) state <= 4'b1000;  // start
	4'b1000: if(BaudTick) state <= 4'b1001;  // bit 0
	4'b1001: if(BaudTick) state <= 4'b1010;  // bit 1
	4'b1010: if(BaudTick) state <= 4'b1011;  // bit 2
	4'b1011: if(BaudTick) state <= 4'b1100;  // bit 3
	4'b1100: if(BaudTick) state <= 4'b1101;  // bit 4
	4'b1101: if(BaudTick) state <= 4'b1110;  // bit 5
	4'b1110: if(BaudTick) state <= 4'b1111;  // bit 6
	4'b1111: if(BaudTick) state <= 4'b0010;  // bit 7
	4'b0010: if(BaudTick) state <= 4'b0011;  // stop1
	4'b0011: if(BaudTick) state <= 4'b0000;  // stop2
	default: if(BaudTick) state <= 4'b0000;
endcase

reg muxbit;			// Output mux
always @( * )
case(state[2:0])
	3'd0: muxbit <= TxD_dataD[0];
	3'd1: muxbit <= TxD_dataD[1];
	3'd2: muxbit <= TxD_dataD[2];
	3'd3: muxbit <= TxD_dataD[3];
	3'd4: muxbit <= TxD_dataD[4];
	3'd5: muxbit <= TxD_dataD[5];
	3'd6: muxbit <= TxD_dataD[6];
	3'd7: muxbit <= TxD_dataD[7];
endcase

reg TxD;	// Put together the start, data and stop bits
always @(posedge clk) TxD <= (state<4) | (state[3] & muxbit);  // register the output to make it glitch free

// --------------------------------------------------------------------
endmodule