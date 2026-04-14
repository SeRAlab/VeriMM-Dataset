module top_module(
    input [LOG_SIZE-1:0] address,
    input enable,
    output reg [(1<<LOG_SIZE)-1:0] bitline
);parameter LOG_SIZE = 0;

    always @(*) begin
        if(enable == 1'b0) begin
            bitline <= 0;
        end else begin
            bitline <= (1 << address);
        end
    end

endmodule