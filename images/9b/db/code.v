module top_module(
    s_in,
    s_out
);//parameters
parameter WIDTH                        =  1;
parameter DELAY_PS                     =  10;

//ports
input  wire [WIDTH - 1 : 0]            s_in;
output reg  [WIDTH - 1 : 0]            s_out;

// synopsys translate_off
wire [WIDTH - 1 : 0] delayed_s_in;

//model the transport delay
assign #(DELAY_PS) delayed_s_in = s_in;
// synopsys translate_on

always @*
begin
// synopsys translate_off
    s_out = delayed_s_in;
// synopsys translate_on
end

endmodule