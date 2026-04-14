module priority_encoder(
    input [3:0]         in  ,   

    output reg [1:0]    out
);

always@(*)
begin
    if(in[3])       out = 2'd3;
    else if(in[2])  out = 2'd2;
    else if(in[1])  out = 2'd1;
    else if(in[0])  out = 2'd0;
    else            out = 2'd0;
end

endmodule