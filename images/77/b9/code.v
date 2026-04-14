module up_down_counter_12bit(
    input               clk     ,
    input               rst     ,
    input               en      ,
    input               up_down ,
    output reg [11:0]   count   
);

always @(posedge clk) begin
    if (rst)
        count <= 12'd0;
    else if (en) begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule