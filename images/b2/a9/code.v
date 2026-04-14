module top_module(
    input clk,
    input reset,
    input start,
    input stop,
    output reg [31:0] count
);reg [31:0] count_reg;
    reg prev_clk;
    
    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 0;
            prev_clk <= 1'b0;
        end else begin
            if (start) begin
                count_reg <= 0;
                prev_clk <= 1'b0;
            end else if (stop) begin
                count <= count_reg;
            end else begin
                if (clk && !prev_clk) begin
                    count_reg <= count_reg + 1;
                end
                prev_clk <= clk;
            end
        end
    end

endmodule