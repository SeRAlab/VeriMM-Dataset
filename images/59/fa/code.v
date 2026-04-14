module top_module(
   clk,
   reset,
   count_out
);input            clk;
    input            reset;
    output  [3:0]    count_out;
                     
    reg  [3:0]        count_out_reg;
                     
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            count_out_reg <= 4'b0000;
        end
        else begin
            count_out_reg <= count_out_reg + 1;
        end
    end
     
    assign count_out = count_out_reg;

endmodule