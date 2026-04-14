module top_module(
    input            clock,
    input            reset_n,
    input            in,
    input            enable,
    output           out,
    output reg [9:0] data
);always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            data <= 10'b10_0000_0000;
        else if (enable)
            data <= { in, data [9:1] };
    end
    
    assign out = data [0];endmodule