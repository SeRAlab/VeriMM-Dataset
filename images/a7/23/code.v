module counter_with_clear(
    input           clk     ,
    input           rst_n   ,
    input           clear   ,
    output  reg [3:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
        end
        else if (clear) begin
            count <= 4'b0;
        end
        else begin
            count <= count + 1;
        end
    end
    
endmodule