module top_module(
    input clk_in,
    input latch_edge,
    output reg clk_out
    );reg [1:0] counter;
    reg prev_latch_edge;
    
    always @(posedge clk_in) begin
        if (prev_latch_edge == 1'b0 && latch_edge == 1'b1) begin
            counter <= 2'b11;
        end else begin
            counter <= counter - 1;
        end
        prev_latch_edge <= latch_edge;
    end
    
    always @(posedge clk_in) begin
        if (counter == 2'b01) begin
            clk_out <= 1'b0;
        end else if (counter == 2'b10) begin
            clk_out <= 1'b1;
        end
    end
endmodule