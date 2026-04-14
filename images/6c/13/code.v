module up_down_counter(
    input           clk       ,
    input           rst_n     ,
    input           enable    ,
    input           direction ,
    output  reg [7:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'b0;
        end
        else if (enable) begin
            if (direction) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
    
endmodule