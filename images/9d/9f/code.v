module sync_up_down_counter_16bit(
    input               clk     ,   
    input               rst     ,
    input               en      ,
    input               up_down ,
    output  reg [15:0]  count    
);

always @(posedge clk) begin
    if (rst)
        count <= 16'd0;
    else if (en) begin
        if (up_down)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule