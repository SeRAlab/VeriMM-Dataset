module reg_16bit(
    input               clk      ,
    input               rst      ,
    input               en       ,
    input [15:0]        data_in  ,
    output reg [15:0]   data_out 
);

always @(posedge clk) begin
    if (rst)
        data_out <= 16'd0;
    else if (en)
        data_out <= data_in;
end

endmodule