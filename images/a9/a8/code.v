module top_module(
    input            clk48,                 
    input            manchester_data_in,    
    output     [7:0] RxData,                
    output           new_byte_available,    
	output           sync_pulse,
    output 		     end_of_frame  			
);reg [2:0] in_data;
always @(posedge clk48) in_data <= {in_data[1:0], manchester_data_in};

reg [1:0] cnt;
always @(posedge clk48) if(|cnt || (in_data[2] ^ in_data[1])) cnt<=cnt+1;

assign 	  RxData = data;
reg [7:0] data;
reg new_bit_avail;
always @(posedge clk48) new_bit_avail <= (cnt==3);
always @(posedge clk48) if(cnt==3) data<={in_data[1],data[7:1]};

reg [4:0] sync1;
always @(posedge clk48)
	if(end_of_Ethernet_frame) sync1<=0; 
	else 
	if(new_bit_avail) begin
		if(!(data==8'h55 || data==8'hAA))  sync1 <= 0;	 
		else
		if(~&sync1) 
                    
			sync1 <= sync1 + 1; 
end

reg [9:0] sync2;
always @(posedge clk48)
	if(end_of_Ethernet_frame) sync2 <= 0;
	else 
	if(new_bit_avail) begin
		if(|sync2) 
			sync2 <= sync2 + 1; 
		else
			if(&sync1 && data==8'hD5) 
				sync2 <= sync2 + 1;
end

assign new_byte_available = new_bit_avail && (sync2[2:0]==3'h0) && (sync2[9:3]!=0);  




reg [2:0] transition_timeout;
always @(posedge clk48) 
	if(in_data[2]^in_data[1]) transition_timeout <= 0; 
	else if(~&cnt) 			  transition_timeout <= transition_timeout + 1;
reg 	  end_of_Ethernet_frame;
always @(posedge clk48) end_of_Ethernet_frame <= &transition_timeout;
assign sync_pulse = end_of_Ethernet_frame;

reg [14:0] frame_timeout;
always @(posedge clk48) 
	if(new_byte_available) 	frame_timeout <= 0; 
	else 			  		frame_timeout <= frame_timeout + 1;
	
reg frame_end;
always @(posedge clk48) begin
	if(&frame_timeout)     frame_end <= 1'b1;
	if(new_byte_available) frame_end <= 1'b0;	
end

assign end_of_frame = frame_end;


endmodule