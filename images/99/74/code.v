module top_module(input clk, rst, en, output reg [3:0] out);always @(posedge clk) begin
        if (rst) begin
            out <= 0; // reset to 0 when rst is asserted
        end else if (en) begin
            out <= out + 1; // increment count value by 1 on each rising edge of clk when en is asserted
        end
    end
endmodule