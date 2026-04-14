module top_module(bus_011957aa_, bus_00ca93e8_, bus_015cd3cf_, bus_00546ebf_, bus_0142775d_);input		bus_011957aa_;
input		bus_00ca93e8_;
input		bus_015cd3cf_;
input		bus_00546ebf_;
output		bus_0142775d_;
reg		stateVar_state_s0_u9=1'h0;
always @(posedge bus_011957aa_ or posedge bus_00ca93e8_)
begin
if (bus_00ca93e8_)
stateVar_state_s0_u9<=1'h0;
else if (bus_015cd3cf_)
stateVar_state_s0_u9<=bus_00546ebf_;
end
assign bus_0142775d_=stateVar_state_s0_u9;endmodule