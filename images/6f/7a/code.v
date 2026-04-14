module top_module(
    input [7:0] dac_in,
    input clk,
    input rst,
    input conv,
    output reg [7:0] dac_out
);parameter RES = 7;
    reg [7:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dac_out <= 0;
            counter <= 0;
        end
        else if (conv) begin
            dac_out[RES:0] <= counter[RES:0];
            counter <= counter + 1;
        end
    end
endmodule