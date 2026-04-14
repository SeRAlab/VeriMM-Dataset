module sync_up_counter_8bit_sync_reset(
    input               clk     ,   
    input               rst     ,
    input               en      ,
    output  reg [7:0]   count    
);

always @(posedge clk) begin
    if (rst)
        count <= 8'd0;
    else if (en)
        count <= count + 1;
end

endmodule