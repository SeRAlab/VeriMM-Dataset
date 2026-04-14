module binary_counter(
    input               clk         ,   
    input               rst_n       ,
    input               enable      ,
 
    output  reg [7:0]   count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;
        end
    end

endmodule