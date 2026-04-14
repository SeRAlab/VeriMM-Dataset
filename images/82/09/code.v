module accumulator_32bit(
    input               clk     ,
    input               load    ,
    input               clr     ,
    input      [31:0]   data_in ,
    output reg [31:0]   acc_out 
);

always @(posedge clk) begin
    if (clr)
        acc_out <= 32'd0;
    else if (load)
        acc_out <= data_in;
    else
        acc_out <= acc_out + data_in;
end

endmodule