module d_ff(
    input               clk     , 
    input               rst     ,
    input               en      ,
    input               d       ,

    output reg          q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 0;
    end else if (en) begin
        q <= d;
    end
end

endmodule