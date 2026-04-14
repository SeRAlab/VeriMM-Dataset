module shift_register(
    input            clk     ,
    input            rstn    ,
    input            load    ,
    input  [3:0]     data_in ,

    output reg [3:0] data_out
);

always @(posedge clk or negedge rstn)
begin
    if (!rstn)          data_out <= 0;
    else if (load)      data_out <= data_in;
    else                data_out <= {1'b0, data_out[3:1]};
end

endmodule