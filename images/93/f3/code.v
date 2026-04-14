module sync_down_counter_12bit(
    input               clk     ,   
    input               rst_n   ,
    input               en      ,
    output  reg [11:0]  count    
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 12'd0;
    else if (en)
        count <= count - 1;
end

endmodule