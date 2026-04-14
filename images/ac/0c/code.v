module sync_down_counter_16bit(
    input               clk     ,   
    input               rst_n   ,
    input               load    ,
    input      [15:0]   load_val,
    output  reg [15:0]  count    
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 16'd0;
    else if (load)
        count <= load_val;
    else
        count <= count - 1;
end

endmodule