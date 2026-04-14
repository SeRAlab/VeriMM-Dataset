module top_module(
    input clk,
    input reset,
    input count_en,
    input load,
    input [3:0] data_in,
    output reg [3:0] count_val,
    output reg overflow,
    output reg underflow
);always @(posedge clk) begin
    if (reset) begin
        count_val <= 4'b0000;
        overflow <= 1'b0;
        underflow <= 1'b0;
    end else if (load) begin
        count_val <= data_in;
        overflow <= 1'b0;
        underflow <= 1'b0;
    end else if (count_en) begin
        if (count_val == 4'b1111) begin
            count_val <= 4'b0000;
            overflow <= 1'b1;
            underflow <= 1'b0;
        end else begin
            count_val <= count_val + 1;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end
    end else begin
        if (count_val == 4'b0000) begin
            count_val <= 4'b1111;
            overflow <= 1'b0;
            underflow <= 1'b1;
        end else begin
            count_val <= count_val - 1;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end
    end
end

endmodule