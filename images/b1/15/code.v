module enable_counter(
    input           clk     ,
    input           rst_n   ,
    input           enable  ,
    output  reg [9:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 10'b0;
        end
        else if (enable) begin
            count <= count + 1;
        end
    end
    
endmodule