module johnson_counter_16bit#(
    parameter width = 16
)(
    input                  clk    ,
    input                  rst    ,

    output reg [width-1:0] q
);

always @(posedge clk) begin
    if(rst)
        q <= {width{1'b0}};
    else
        q <= {q[width-2:0], ~q[width-1]};
end

endmodule