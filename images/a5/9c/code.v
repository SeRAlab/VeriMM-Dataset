module priority_encoder_4bit#(
    parameter width_in = 4,
    parameter width_out = 2
)(
    input  [width_in-1:0]  in    ,

    output reg [width_out-1:0] out   ,
    output reg               valid
);

always @(*) begin
    valid = (in != 0);
    if(in[3])
        out = 2'd3;
    else if(in[2])
        out = 2'd2;
    else if(in[1])
        out = 2'd1;
    else if(in[0])
        out = 2'd0;
    else
        out = {width_out{1'bx}};
end

endmodule