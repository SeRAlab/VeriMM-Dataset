module binary_down_counter_6bit(
    input               clk     ,   
    input               rst_n   ,
    input               en      ,
    output  reg [5:0]   count    
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 6'd63;
    else if (en)
        count <= count - 1;
end

endmodule