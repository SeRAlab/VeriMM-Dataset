module clock_divider(
    input           clk     ,
    input           rst_n   ,
    output  reg     clk_out
);
    
    reg [1:0] counter;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b0;
            clk_out <= 1'b0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out;
            end
        end
    end
    
endmodule