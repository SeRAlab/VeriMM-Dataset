module top_module(
    input [3:0] in,
    input enable,
    input [2:0] select,
    output reg [15:0] out
);always @(*) begin
        if (enable == 1'b0) begin
            out <= 16'b0;
        end else begin
            case (select)
                3'b000: out <= 16'b0000000000000001;
                3'b001: out <= 16'b0000000000000010;
                3'b010: out <= 16'b0000000000000100;
                3'b011: out <= 16'b0000000000001000;
                3'b100: out <= 16'b0000000000010000;
                3'b101: out <= 16'b0000000000100000;
                3'b110: out <= 16'b0000000001000000;
                3'b111: out <= 16'b0000000010000000;
                default: out <= 16'b0;
            endcase
        end
    end

endmodule