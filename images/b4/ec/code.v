module top_module(bus_004c40a3_, bus_0179ab19_, bus_010eecea_);input		bus_004c40a3_;
input		bus_0179ab19_;
output		bus_010eecea_;
wire		not_00193e04_u0;
reg		final_u12=1'h1;
reg		glitch_u12=1'h0;
reg		cross_u12=1'h0;
wire		and_0004e0bc_u0;
reg		sample_u12=1'h0;
wire		or_00d00673_u0;
assign not_00193e04_u0=~and_0004e0bc_u0;
always @(posedge bus_004c40a3_)
begin
final_u12<=not_00193e04_u0;
end
always @(posedge bus_004c40a3_)
begin
glitch_u12<=cross_u12;
end
always @(posedge bus_004c40a3_)
begin
cross_u12<=sample_u12;
end
assign and_0004e0bc_u0=cross_u12&glitch_u12;
always @(posedge bus_004c40a3_)
begin
sample_u12<=1'h1;
end
assign or_00d00673_u0=bus_0179ab19_|final_u12;
assign bus_010eecea_=or_00d00673_u0;endmodule