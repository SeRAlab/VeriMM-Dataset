module top_module(
clk,sck,mosi,miso,ssel,rst_n,recived_status
);input clk;
input rst_n;
input sck,mosi,ssel;
output miso;
output recived_status;

reg recived_status;
reg sselr;

reg [7:0] byte_data_sent;
reg [7:0] next_byte_data_sent;
reg [7:0] bit_cnt;


wire ssel_active;
wire sck_risingedge;
wire sck_fallingedge;
wire ssel_startmessage;
wire ssel_endmessage;


reg curr, last;
always@(posedge clk)
begin
	if(!rst_n) begin
		curr <= 1'b0;
		last <= 1'b0;
	end
	else begin
    curr <= sck;
    last <= curr;
	end
end

assign sck_risingedge = curr & (~last);



assign sck_fallingedge = ~curr & (last);



always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		sselr <= 1'h1;
	else
		sselr <= ssel;
end

assign  ssel_active = (~sselr) ? 1'b1 : 1'b0;  






always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		byte_data_sent <= 8'h1;
		next_byte_data_sent <= 8'h2;
		bit_cnt <= 8'h0;
	 end
	 else begin
      if(ssel_active && sck_fallingedge) 
		begin
          if(next_byte_data_sent == 8'h41)
               next_byte_data_sent <= 8'h1;
			 if (bit_cnt == 8'h7f)
			   begin
						byte_data_sent <= next_byte_data_sent;
						bit_cnt <= {bit_cnt[6:0], 1'b1};
				 end
			 else
			   byte_data_sent <= {byte_data_sent[6:0], 1'b0};
          
			 bit_cnt <= {bit_cnt[6:0], 1'b1}; 
		end
		else begin
			if(ssel_active && sck_risingedge) begin
				 
				 if(bit_cnt == 8'hff)
				  begin
					 bit_cnt <= 8'h0;
					 next_byte_data_sent <= next_byte_data_sent + 1;
				 end
		 
			end
		end
	end
end


assign miso = byte_data_sent[7];  


endmodule