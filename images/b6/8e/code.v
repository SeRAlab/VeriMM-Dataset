module top_module(reset_n,
		clock,
		sda_in,
		scl);input		clock;   
input		reset_n;
input		sda_in;
input		scl;


reg		start_bus_reg;
reg		stop_bus_reg;
wire sda_risingedge;
wire scl_risingedge;
wire sda_failingedge;
wire scl_fallingedge;

reg curr, last;
always@(posedge clock)
begin
	if(!reset_n) begin
		curr <= 1'b0;
		last <= 1'b0;
	end
	else begin
    curr <= scl;
    last <= curr;
	end
end

assign scl_risingedge = curr & (~last);


assign scl_fallingedge = ~curr & (last);

reg sda_curr, sda_last;
always@(posedge clock)
begin
	if(!reset_n) begin
		sda_curr <= 1'b0;
		sda_last <= 1'b0;
	end
	else begin
    sda_curr <= sda_in;
    sda_last <= sda_curr;
	end
end


assign sda_risingedge = sda_curr & (~sda_last);


assign sda_fallingedge = ~sda_curr & (sda_last);




always@(posedge clock)
begin
  start_bus_reg <= sda_fallingedge & scl;
  stop_bus_reg <= sda_risingedge & scl;
end

endmodule