module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [31:0] data,
    output reg [31:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q << 1;  // Shift left by 1 bit
                2'b01: q <= q << 2;  // Shift left by 2 bits
                2'b10: q <= $signed(q) >>> 1;  // Arithmetic shift right by 1 bit
                2'b11: q <= $signed(q) >>> 2;  // Arithmetic shift right by 2 bits
                default: q <= q;  // No change
            endcase
        end
    end

endmodule