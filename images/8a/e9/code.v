module gray_code_counter(
    input clk,
    input reset,
    output reg [2:0] gray_code
    );
    
    always @(posedge clk) begin
        if (reset)
            gray_code <= 3'b000;
        else
            gray_code <= (gray_code + 1) ^ ((gray_code + 1) >> 1);
    end
endmodule