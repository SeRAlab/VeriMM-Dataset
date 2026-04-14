module top_module(
    input clk,
    input load,
    input [3:0] data,
    input [1:0] shift,
    output reg [3:0] result
);always @(posedge clk) begin
    if (load) begin
        result <= data;
    end else begin
        case (shift)
            2'b00: result <= result; // no shift
            2'b01: result <= {result[2:0], data[3]}; // shift left by 1
            2'b10: result <= {data[0], result[3:1]}; // shift right by 1
            2'b11: result <= {data[1:0], result[3:2]}; // shift right by 2
            default: result <= result; // no shift
        endcase
    end
end

endmodule