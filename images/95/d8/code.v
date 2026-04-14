module ring_counter_3bit(
    input               clk     ,   
    input               rst_n   ,
    input               en      ,
    output  reg [2:0]   count    
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 3'b001;
    else if (en)
        count <= {count[1:0], count[2]};
end

endmodule