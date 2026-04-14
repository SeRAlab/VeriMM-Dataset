module gray_code_counter (
    input clk,
    input reset,
    input en,
    output reg [11:0] q);

function [11:0] gray_code;
    input [11:0] bin;
    gray_code = bin ^ (bin >> 1);
endfunction

always @(posedge clk) begin
    if (reset)
        q <= 12'b000000000000;
    else if (en)
        q <= gray_code(q + 1);
end

endmodule