module sync_up_counter_10bit_with_load(
    input               clk         ,   
    input               rst         ,
    input               en          ,
    input               load        ,
    input   [9:0]       load_value  ,
    output  reg [9:0]   count       
);

always @(posedge clk) begin
    if (rst)
        count <= 10'd0;
    else if (load)
        count <= load_value;
    else if (en)
        count <= count + 1;
end

endmodule