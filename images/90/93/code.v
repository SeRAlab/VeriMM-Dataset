module top_module(input wire[3:0] in_val, output reg[3:0] out_val);always @(in_val) begin
    if (in_val <= 4) begin
        out_val <= in_val + 4;
    end else begin
        out_val <= in_val + 3;
    end
end

endmodule