module top_module(
    input [3:0] in_data,
    input [1:0] sel,
    output reg [1:0] out_data
);always @(*) begin
        case (sel)
            2'b00: out_data = ~in_data + 1; // 2's complement
            2'b01: out_data = {in_data[2:0], 1'b0}; // shift left
            default: out_data = 2'b00; // default value
        endcase
    end

endmodule