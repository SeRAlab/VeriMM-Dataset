module top_module(
    s_in,
    s_out
);parameter WIDTH                        =  1;
parameter DELAY_PS                     =  10;


input  wire [WIDTH - 1 : 0]            s_in;
output reg  [WIDTH - 1 : 0]            s_out;


wire [WIDTH - 1 : 0] delayed_s_in;


assign #(DELAY_PS) delayed_s_in = s_in;


always @*
begin
    s_out = s_in;

    s_out = delayed_s_in;

end

endmodule