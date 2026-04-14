module top_module(rx_in , check_stop,rx_data_in,stop_bit_error,rx_data_out);input rx_in , check_stop;
input [7:0] rx_data_in;
output reg stop_bit_error;
output reg [7:0]rx_data_out;

always @(*)
begin
if(check_stop)
begin
if(rx_in==1)
begin
stop_bit_error<=0;
rx_data_out<=rx_data_in;
end
else
stop_bit_error<=1;
end
end
endmodule