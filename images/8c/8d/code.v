module mux_2_to_1(
    input               sel     ,   
    input [7:0]         in0     ,
    input [7:0]         in1     ,

    output reg [7:0]    out
);

always@(*)
begin
    if(sel)     out = in1;
    else        out = in0;
end

endmodule