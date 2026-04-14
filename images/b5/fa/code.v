module shift_register_32bit#(
    parameter width = 32
)(
    input                  clk        ,
    input                  rst        ,
    input                  load       ,
    input  [width-1:0]     data_in    ,
    input                  shift_in   ,

    output reg [width-1:0] data_out
);

always @(posedge clk) begin
    if(rst)
        data_out <= {width{1'b0}};
    else if(load)
        data_out <= data_in;
    else
        data_out <= {data_out[width-2:0], shift_in};
end

endmodule