module reg_16bit(
    input               clk     ,   
    input               rst_n   ,
    input               load    ,
    input      [15:0]   data_in ,
    output reg [15:0]   data_out
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 16'd0;
    else if (load)
        data_out <= data_in;
end

endmodule