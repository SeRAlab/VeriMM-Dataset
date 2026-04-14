module gray_code_counter_2bit(
    input               clk     ,   
    input               rst     ,
    input               en      ,
    output  reg [1:0]   count    
);

always @(posedge clk) begin
    if (rst)
        count <= 2'b00;
    else if (en)
        count <= {count[1] ^ count[0], count[0] ^ 1'b1};
end

endmodule